#!/usr/bin/env ruby

require "json"
require "socket"

module HerdrEqualizePanes
  module_function

  def pane_count(node)
    return 1 if node.fetch("type") == "pane"

    pane_count(node.fetch("first")) + pane_count(node.fetch("second"))
  end

  def split_ratios(node, path = [], ratios = [])
    return ratios if node.fetch("type") == "pane"

    first = node.fetch("first")
    second = node.fetch("second")
    first_count = pane_count(first)
    ratios << [path, first_count.fdiv(first_count + pane_count(second))]
    split_ratios(first, path + [false], ratios)
    split_ratios(second, path + [true], ratios)
    ratios
  end

  def request(socket_path, id:, method:, params:)
    UNIXSocket.open(socket_path) do |socket|
      socket.puts(JSON.generate(id: id, method: method, params: params))
      response = JSON.parse(socket.gets || raise("Herdr socket closed without a response"))
      error = response["error"]
      raise(error["message"] || error.inspect) if error

      response.fetch("result")
    end
  end

  def run(env = ENV)
    socket_path = env.fetch("HERDR_SOCKET_PATH")
    tab_id = env["HERDR_ACTIVE_TAB_ID"] || env.fetch("HERDR_TAB_ID")

    exported = request(
      socket_path,
      id: "equalize-export",
      method: "layout.export",
      params: { tab_id: tab_id }
    )

    split_ratios(exported.fetch("layout").fetch("root")).each_with_index do |(path, ratio), index|
      request(
        socket_path,
        id: "equalize-ratio-#{index}",
        method: "layout.set_split_ratio",
        params: { tab_id: tab_id, path: path, ratio: ratio }
      )
    end
  end
end

HerdrEqualizePanes.run if $PROGRAM_NAME == __FILE__
