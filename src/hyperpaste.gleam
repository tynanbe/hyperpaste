import gleam/io
import gleam/iterator
import gleam/string
import shellout.{StderrToStdout}

pub const char_limit = 720

pub fn main(args: List(String)) -> NoReturn {
  case shellout.cmd("xsel", ["-ob"], [StderrToStdout(True)]) {
    Ok(#(output, status)) -> {
      case 0 == status {
        False -> iterator.from_list(output)
        True -> {
          let chunk_size = char_limit

          iterator.from_list(output)
        }
      }
      |> iterator.map(with: io.println)
      |> iterator.run
      status
    }

    Error(reason) -> {
      io.println(reason)
      1
    }
  }
  |> halt
}

pub external type NoReturn

pub external fn halt(status: Int) -> NoReturn =
  "erlang" "halt"
