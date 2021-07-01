import gleam/int
import gleam/iterator
import gleam/result
import gleam/string
import gleam/string_builder
import shellout.{StderrToStdout}

pub const default_chunk_size = 3996

pub fn main(args: List(String)) -> NoReturn {
  case shellout.cmd("xsel", ["-ob"], [StderrToStdout(True)]) {
    Ok(#(output, status)) -> {
      let chunk_size = case args {
        [chunk_size, .._] ->
          chunk_size
          |> int.parse
          |> result.unwrap(default_chunk_size)
        _ -> default_chunk_size
      }
      output
      |> iterator.from_list
      |> iterator.map(with: fn(line) {
        line
        |> string.to_graphemes
        |> iterator.from_list
        |> iterator.sized_chunk(into: chunk_size)
        |> iterator.map(with: fn(chunk) {
          let chunk =
            chunk
            |> string_builder.from_strings
            |> string_builder.to_string
          shellout.cmd("xdopaste", [chunk], [StderrToStdout(True)])
        })
        |> iterator.run
      })
      |> iterator.run
      status
    }

    Error(reason) -> {
      shellout.cmd("xdopaste", [reason], [StderrToStdout(True)])
      1
    }
  }
  |> halt
}

pub external type NoReturn

pub external fn halt(status: Int) -> NoReturn =
  "erlang" "halt"
