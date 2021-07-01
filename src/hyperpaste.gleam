import gleam/int
import gleam/iterator
import gleam/result
import shellout.{StderrToStdout}

pub const default_chunk_size = 720

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
        shellout.cmd("xdopaste", [line], [StderrToStdout(True)])
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
