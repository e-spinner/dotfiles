#include <fstream>
#include <iostream>
#include <string>

#include "font.hpp"

using namespace std;

void render_ascii_string(const string &input, std::ostream &out) {
  const int HEIGHT = 8;
  char next        = ' ';
  char above       = ' ';
  char above_next  = ' ';

  // top of frame
  // ------------------------------------------------------------------------
  out << " __";
  for (char ch : input) {
    out << '_';
    for (char col : ascii_map[ch][0]) out << "___";
  }
  out << "___\n";
  out << "/\\  ";
  for (char ch : input) {
    out << ' ';
    for (char col : ascii_map[ch][0]) out << "   ";
  }
  out << "  \\\n";

  for (int row = 0; row < HEIGHT + 1; row++) {
    // Left of frame
    // ------------------------------------------------------------------------
    out << "\\ \\  ";
    for (char ch : input) {

      for (int col = 0; col < ascii_map[ch][row].size(); col++) {

        char box = ascii_map[ch][row][col];

        // find relatives
        // ------------------------------------------------------------------------
        if (col < ascii_map[ch][row].size())
          next = ascii_map[ch][row][col + 1];
        else
          next = '-';

        if (row > 0)
          above = ascii_map[ch][row - 1][col];
        else
          above = '-';

        if (col < ascii_map[ch][row].size() && row > 0)
          above_next = ascii_map[ch][row - 1][col + 1];
        else
          above_next = '-';

        // print
        // ------------------------------------------------------------------------

        if (box == '+') {
          out << "\\\\\\";

        } else {
          if (above == '+') {
            if (next == '+')
              out << "__/";
            else {
              if (above_next == '+')
                out << "___";
              else
                out << "_/ ";
            }
          } else {
            if (next == '+') {
              if (above_next == '+')
                out << " \\ ";
              else
                out << "  /";
            } else {
              if (above_next == '+')
                out << " \\/";
              else
                out << "   ";
            }
          }
        }
      }
      out << " ";
    }
    // right of frame
    // ------------------------------------------------------------------------
    out << "  \\";
    out << "\n";
    for (int o = 0; o < row + 1; o++) out << ' ';
  }

  // bottom of frame
  // ------------------------------------------------------------------------
  out << "\\ \\__";
  for (char ch : input) {
    out << '_';
    for (char col : ascii_map[ch][0]) out << "___";
  }
  out << "__\\\n";
  out << "         ";
  out << "\\/___";
  for (char ch : input) {
    out << '_';
    for (char col : ascii_map[ch][0]) out << "___";
  }
  out << "__/\n";
}

int main(int argc, char **argv) {
  std::string input;
  std::ostream *out = &std::cout; // default to stdout
  std::ofstream file;

  // parse args
  //   for (int i = 1; i < argc; ++i) {
  //     std::string arg = argv[i];
  //     if (arg == "-f" && i + 1 < argc) {
  //       file.open(argv[++i]);
  //       if (!file) {
  //         std::cerr << "Failed to open file: " << argv[i] << '\n';
  //         return 1;
  //       }
  //       out = &file;
  //     } else {
  //       input += arg + " ";
  //     }
  //   }

  input = argv[1];

  if (input.empty()) {
    std::cout << "Enter a string: ";
    std::getline(std::cin, input);
  }

  render_ascii_string(input, *out);

  return 0;
}
