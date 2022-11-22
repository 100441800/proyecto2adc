#include "bitmap_soa.hpp"
#include "common/file_error.hpp"
#include <fstream>

#include <omp.h>

namespace images::soa {

  bitmap_soa::bitmap_soa(int w, int h) : header{w, h},
                                         pixels{std::vector<uint8_t>(header.image_size()),
                                                std::vector<uint8_t>(header.image_size()),
                                                std::vector<uint8_t>(header.image_size())} {
  }

  void bitmap_soa::read(const std::filesystem::path & in_name) {
    std::ifstream in{in_name};
    if (!in) {
      throw file_error{file_error_kind::cannot_open};
    }
    header.read(in);

    const int extra = (width() * 3) % 4;
    const int pixels_size = height() * width();
    for (auto & p: pixels) {
      p.reserve(pixels_size);
    }
    for (int r = 0; r < height(); ++r) {
      for (int c = 0; c < width(); ++c) {
        pixel pixel_value{};
        pixel_value.read(in);
        pixels[red_channel].push_back(pixel_value.red());
        pixels[green_channel].push_back(pixel_value.green());
        pixels[blue_channel].push_back(pixel_value.blue());
      }
      if (extra != 0) {
        in.ignore(4 - extra);
      }
    }

  }

  namespace {
    void write_padding(std::ostream & os, int n) noexcept {
      std::array<uint8_t, 3> pad_pixel{};
      // NOLINTNEXTLINE(cppcoreguidelines-pro-type-reinterpret-cast)
      os.write(reinterpret_cast<char *>(pad_pixel.data()), n);
    }
  }

  void bitmap_soa::write(const std::filesystem::path & out_name) {
    std::ofstream out{out_name};
    if (!out) {
      throw file_error{file_error_kind::cannot_open};
    }

    header.write(out);
    const int padding = (4 - (width() * 3) % 4) % 4;
    for (int r = 0; r < height(); ++r) {
      for (int c = 0; c < width(); ++c) {
        auto pixel_value = get_pixel(r, c);
        pixel_value.write(out);
      }
      write_padding(out, padding);
    }
  }

  void bitmap_soa::to_gray() noexcept {
    const auto max = header.image_size();

    std::vector<uint8_t> pixels_mono_red;
    pixels_mono_red.reserve(max);
    std::vector<uint8_t> pixels_mono_green;
    pixels_mono_red.reserve(max);
    std::vector<uint8_t> pixels_mono_blue;
    pixels_mono_red.reserve(max);

    #pragma omp parallel 
    {
      std::vector<uint8_t> pixels_mono_red_private;
      std::vector<uint8_t> pixels_mono_green_private;
      std::vector<uint8_t> pixels_mono_blue_private;
      #pragma omp for nowait
      for (int i = 0; i < max; ++i) {
        const auto gray_level = to_gray_corrected(pixels[red_channel][i], pixels[green_channel][i],
        pixels[blue_channel][i]);
        pixels_mono_red_private.push_back(gray_level);
        pixels_mono_green_private.push_back(gray_level);
        pixels_mono_blue_private.push_back(gray_level);
      }

      #pragma omp for ordered
      for(int i = 0; i < omp_get_num_threads(); ++i) {
        #pragma omp ordered
        {
          pixels_mono_red.insert(pixels_mono_red.end(), pixels_mono_red_private.begin(), pixels_mono_red_private.end());
          pixels_mono_green.insert(pixels_mono_green.end(), pixels_mono_green_private.begin(), pixels_mono_green_private.end());
          pixels_mono_blue.insert(pixels_mono_blue.end(), pixels_mono_blue_private.begin(), pixels_mono_blue_private.end());
        }
      }
    }

    pixels[red_channel] = pixels_mono_red;
    pixels[green_channel] = pixels_mono_green;
    pixels[blue_channel] = pixels_mono_blue;
  
  }

  bool bitmap_soa::is_gray() const noexcept {
    const auto max = std::ssize(pixels);
    bool cond = true;
    for (int i = 0; i < max && cond; ++i) {
      const auto p = get_pixel(i);
      cond = (!p.is_gray()) ? false : true ;
    }
    return cond;
  }

  namespace {
    constexpr std::array<int, 25> gauss_kernel{1, 4, 7, 4, 1, 4, 16, 26, 16, 4, 7, 26, 41, 26, 7, 4,
                                               16, 26, 16, 4, 1, 4, 7, 4, 1};

    constexpr int gauss_norm = 273;
    constexpr auto gauss_size = std::ssize(gauss_kernel);
  }

  void bitmap_soa::gauss() noexcept {
    bitmap_soa result{*this};
    const auto num_pixels = std::ssize(pixels[red_channel]);
    const auto [pixels_width, pixels_height] = get_size();
    color_accumulator accum;
    color_accumulator null_accum({0,0,0});
    int row = 0;
    int column = 0;
    #pragma omp parallel for firstprivate(null_accum, accum, row, column, gauss_kernel)
    for (int pixel_index = 0; pixel_index < num_pixels; ++pixel_index) {
      for (int gauss_index = 0; gauss_index < gauss_size; ++gauss_index) {
        (gauss_index == 0) ? (accum = null_accum, 
                              row = pixel_index / pixels_width,
                              column = pixel_index % pixels_width): (row); 

        const int column_offset = (gauss_index % 5) - 2;
        const int j = column + column_offset;
        bool stay_in_loop = true;
        stay_in_loop = (j < 0 || j >= pixels_width) ? false : stay_in_loop;
        const int row_offset = (gauss_index / 5) - 2;
        const int i = row + row_offset;
        stay_in_loop = (i < 0 || i >= pixels_height) ? false : stay_in_loop;
        // NOLINTNEXTLINE(cppcoreguidelines-pro-bounds-constant-array-index)
        const int gauss_value = gauss_kernel[gauss_index];
        const auto gauss_pixel_index = i * pixels_width + j;
        accum += (stay_in_loop) ? get_pixel(gauss_pixel_index) * gauss_value : null_accum;
      }
      result.set_pixel(pixel_index, pixel{accum / gauss_norm});
    }
    *this = result;
  }

  histogram bitmap_soa::generate_histogram() const noexcept {
    const int pixel_count = width() * height();
    int red[256] = {0};
    int green[256] = {0};
    int blue[256] = {0};
    #pragma omp parallel for reduction(+:red[:256], green[:256], blue[:256])
    for (int i = 0; i < pixel_count; ++i) {
      red[pixels[red_channel][i]]++;
      green[pixels[green_channel][i]]++;
      blue[pixels[blue_channel][i]]++;
    }
    std::array<std::vector<int>, 3> channels = {std::vector<int>(blue, blue+256),
                                                std::vector<int>(green, green+256),
                                                std::vector<int>(red, red+256),};
    histogram histo(channels);
    return histo;
  }

  void bitmap_soa::print_info(std::ostream & os) const noexcept {
    header.print_info(os);
  }

  pixel bitmap_soa::get_pixel(int r, int c) const noexcept {
    auto i = index(r, c);
    return get_pixel(i);
  }

  void bitmap_soa::set_pixel(int r, int c, pixel p) noexcept {
    auto i = index(r, c);
    set_pixel(i, p);
  }

  pixel bitmap_soa::get_pixel(int i) const noexcept {
    pixel p{pixels[red_channel][i], pixels[green_channel][i], pixels[blue_channel][i]};
    return p;
  }

  void bitmap_soa::set_pixel(int i, pixel p) noexcept {
    pixels[red_channel][i] = p.red();
    pixels[green_channel][i] = p.green();
    pixels[blue_channel][i] = p.blue();
  }

  int bitmap_soa::index(int r, int c) const noexcept {
    return r * width() + c;
  }

} // namespace images::soa
