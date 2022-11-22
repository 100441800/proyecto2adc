#include "bitmap_aos.hpp"
#include "common/file_error.hpp"
#include <fstream>
#include <tuple>

#include <array>
#include <vector>

#include <omp.h>

namespace images::aos {

bitmap_aos::bitmap_aos(int w, int h)
    : header{w, h}, pixels(static_cast<std::size_t>(w * h)) {}

void bitmap_aos::read(const std::filesystem::path &in_name) {
  using namespace images::common;
  std::ifstream in{in_name};
  if (!in) {
    throw file_error{file_error_kind::cannot_open};
  }
  header.read(in);

  const int extra = (width() * 3) % 4;
  const int pixels_size = height() * width();
  pixels.reserve(pixels_size);
  for (int r = 0; r < height(); ++r) {
    for (int c = 0; c < width(); ++c) {
      pixel pixel_value{};
      pixel_value.read(in);
      pixels.push_back(pixel_value);
    }
    if (extra != 0) {
      in.ignore(4 - extra);
    }
  }
}

namespace {
void write_padding(std::ostream &os, int n) noexcept {
  std::array<uint8_t, 3> pad_pixel{};
  // NOLINTNEXTLINE(cppcoreguidelines-pro-type-reinterpret-cast)
  os.write(reinterpret_cast<char *>(pad_pixel.data()), n);
}
} // namespace

void bitmap_aos::write(const std::filesystem::path &out_name) {
  using namespace images::common;
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

void bitmap_aos::to_gray() noexcept {
  const auto max = std::ssize(pixels);
  std::vector<pixel> pixels_mono;
  pixels_mono.reserve(max);
  #pragma omp parallel
  {
    std::vector<pixel> pixels_mono_private; // Vector created by each thread
    #pragma omp for nowait
    for (int i = 0; i < max; ++i) {
      pixels_mono_private.push_back(pixels[i].to_gray_corrected());
    }
    #pragma omp for ordered
    for (int i = 0; i < omp_get_num_threads(); ++i) {
      #pragma omp ordered
      pixels_mono.insert(pixels_mono.end(), pixels_mono_private.begin(),
                         pixels_mono_private.end());
    }
  }
  pixels = pixels_mono;
}

bool bitmap_aos::is_gray() const noexcept {
  const auto max = std::ssize(pixels);
  bool cond = true;
  for (int i = 0; i < max && cond; ++i) {
    cond = (!pixels[i].is_gray()) ? false : true;
  }
  return cond;
}

namespace {
constexpr std::array<int, 25> gauss_kernel{1,  4, 7,  4,  1,  4, 16, 26, 16,
                                           4,  7, 26, 41, 26, 7, 4,  16, 26,
                                           16, 4, 1,  4,  7,  4, 1};
// constexpr std::array<int, 5> gauss_one_dimension_kernel = {1, 4, 7, 4, 1};
constexpr int gauss_norm = 273;
// constexpr int gauss_one_dimension_norm = 17;
constexpr auto gauss_size = std::ssize(gauss_kernel);
// constexpr auto gauss_one_dimension_size =
// std::ssize(gauss_one_dimension_kernel);
} // namespace

void bitmap_aos::gauss() noexcept {
  bitmap_aos result{*this};
  const auto num_pixels = std::ssize(pixels);
  const auto [pixels_width, pixels_height] = get_size();
  color_accumulator accum;
  color_accumulator null_accum({0, 0, 0});
  int row = 0;
  int column = 0;
  #pragma omp parallel for firstprivate(null_accum, accum, row, column,          \
                                      gauss_kernel)
  for (int pixel_index = 0; pixel_index < num_pixels; ++pixel_index) {
    for (int gauss_index = 0; gauss_index < gauss_size; ++gauss_index) {
      // Reset accum, row and column at the start of the loop
      (gauss_index == 0)
          ? (accum = null_accum, row = pixel_index / pixels_width,
             column = pixel_index % pixels_width)
          : (row);

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
      accum +=
          (stay_in_loop) ? pixels[gauss_pixel_index] * gauss_value : null_accum;
    }
    result.pixels[pixel_index] = accum / gauss_norm;
  }
  *this = result;
}

/* One dimension version with time 6*O(n)
  bitmap_aos result{*this};
  const auto num_pixels = std::ssize(pixels);

  std::vector<color_accumulator> image_accum_row;
  image_accum_row.reserve(num_pixels);
  this->gauss_rows(image_accum_row);

  std::vector<color_accumulator> image_accum_column;
  image_accum_column.reserve(num_pixels);
  this->gauss_columns(image_accum_row, image_accum_column);

  for (int pixel_index = 0; pixel_index < num_pixels; ++pixel_index) {
    result.pixels[pixel_index] = image_accum_column[pixel_index] / gauss_norm;
  }
  *this = result;
}
*/

/*
void bitmap_aos::gauss_rows(std::vector<color_accumulator> & image_accum)
noexcept { const auto num_pixels = std::ssize(pixels); const auto [pixels_width,
pixels_height] = get_size(); color_accumulator no_color(0, 0, 0); for (int
pixel_index = 0; pixel_index < num_pixels; ++pixel_index) { color_accumulator
accum; const auto [row, column] = get_pixel_position(pixel_index); accum +=
((column) - 2 >= 0) ? pixels[index(row, column - 2)] *
gauss_one_dimension_kernel[0] : no_color; accum += ((column) - 1 >= 0) ?
pixels[index(row, column - 1)] * gauss_one_dimension_kernel[1] : no_color; accum
+= pixels[index(row, column)] * gauss_one_dimension_kernel[2]; accum +=
((column) + 1 < pixels_width) ? pixels[index(row, column + 1)] *
gauss_one_dimension_kernel[3] : no_color; accum += ((column) + 2 < pixels_width)
? pixels[index(row, column + 2)] * gauss_one_dimension_kernel[4] : no_color;
    image_accum[pixel_index] = accum;
  }
}

void bitmap_aos::gauss_columns(std::vector<color_accumulator> & image_accum_row,
                               std::vector<color_accumulator> &
image_accum_column) noexcept { const auto num_pixels = std::ssize(pixels); const
auto [pixels_width, pixels_height] = get_size(); color_accumulator no_color(0,
0, 0); for (int pixel_index = 0; pixel_index < num_pixels; ++pixel_index) {
    color_accumulator accum;
    const auto [row, column] = get_pixel_position(pixel_index);
    accum += ((row) - 2 >= 0) ? image_accum_row[index(row - 2, column)] *
gauss_one_dimension_kernel[0] : no_color; accum += ((row) - 1 >= 0) ?
image_accum_row[index(row - 1, column)] * gauss_one_dimension_kernel[1] :
no_color; accum += image_accum_row[index(row, column)] *
gauss_one_dimension_kernel[2]; accum += ((row) + 1 < pixels_height) ?
image_accum_row[index(row + 1, column)] * gauss_one_dimension_kernel[3] :
no_color; accum += ((row) + 2 < pixels_height) ? image_accum_row[index(row + 2,
column)] * gauss_one_dimension_kernel[4] : no_color;
    image_accum_column[pixel_index] = accum;
  }
}
*/

histogram bitmap_aos::generate_histogram() const noexcept {
  const int pixel_count = width() * height();
  int red[256] = {0};
  int green[256] = {0};
  int blue[256] = {0};
  #pragma omp parallel for reduction(+ : red[:256], green[:256], blue[:256])
  for (int i = 0; i < pixel_count; ++i) {
    red[pixels[i].red()]++;
    green[pixels[i].green()]++;
    blue[pixels[i].blue()]++;
  }
  std::array<std::vector<int>, 3> channels = {
      std::vector<int>(blue, blue + 256),
      std::vector<int>(green, green + 256),
      std::vector<int>(red, red + 256),
  };
  histogram histo(channels);
  return histo;
}

void bitmap_aos::print_info(std::ostream &os) const noexcept {
  header.print_info(os);
}

pixel bitmap_aos::get_pixel(int r, int c) const noexcept {
  return pixels[index(r, c)];
}

void bitmap_aos::set_pixel(int r, int c, pixel p) noexcept {
  pixels[index(r, c)] = p;
}

int bitmap_aos::index(int r, int c) const noexcept { return r * width() + c; }

void print_diff(const bitmap_aos &bm1, const bitmap_aos &bm2) noexcept {
  std::cout << "Printing differences:\n";
  print_diff(bm1.header, bm2.header);
  const auto num_pixels = std::ssize(bm1.pixels);
  for (int i = 0; i < num_pixels; ++i) {
    if (bm1.pixels[i] != bm2.pixels[i]) {
      std::cout << "  Pixel " << i << " is different";
      std::cout << bm1.pixels[i] << " -- " << bm2.pixels[i] << "\n";
      return;
    }
  }
  std::cout << "All pixels are equal\n";
}

} // namespace images::aos
