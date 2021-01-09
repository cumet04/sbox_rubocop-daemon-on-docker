# frozen_string_literal: true

require 'socket'
require 'stringio'
require 'rubocop'

def entry_point
  server = TCPServer.open(
    ENV.fetch('HOST', '0.0.0.0'),
    ENV.fetch('PORT', 3000)
  )
  loop do
    handle_request(server.accept)
  rescue Interrupt
    server.close
    break
  end
end

def handle_request(socket)
  argv = socket.readline.split(' ')
  stdin = socket.read

  status, out = run(argv, stdin)

  socket.puts(status)
  socket.puts(out)
rescue StandardError => e
  socket.puts e.full_message
ensure
  socket.close
end

def run(argv, stdin)
  out = StringIO.new
  status = wrap(
    stdin: StringIO.new(stdin),
    stdout: out,
    stderr: $stderr
  ) do
    RuboCop::CLI.new.run(argv)
  end
  [status, out.string]
end

ORIG_STDIN = $stdin.dup
ORIG_STDOUT = $stdout.dup
ORIG_STDERR = $stderr.dup
def wrap(stdin: $stdin, stdout: $stdout, stderr: $stderr, &_block)
  # refs https://github.com/fohte/rubocop-daemon/blob/master/lib/rubocop/daemon/helper.rb
  $stdin = stdin
  $stdout = stdout
  $stderr = stderr
  yield
ensure
  $stdin = ORIG_STDIN
  $stdout = ORIG_STDOUT
  $stderr = ORIG_STDERR
end

entry_point
