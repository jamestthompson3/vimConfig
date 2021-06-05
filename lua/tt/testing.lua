local function create_server(host, port, on_connect)
	local server = vim.loop.new_tcp()
	server:bind(host, port)
	server:listen(128, function(err)
		assert(not err, err) -- Check for errors.
		local sock = vim.loop.new_tcp()
		server:accept(sock) -- Accept client connection.
		on_connect(sock) -- Start reading messages.
	end)
	return server
end

local server = create_server("0.0.0.0", 0, function(sock)
	sock:read_start(function(err, chunk)
		assert(not err, err) -- Check for errors.
		if chunk then
			sock:write(chunk) -- Echo received messages to the channel.
		else -- EOF (stream closed).
			sock:close() -- Always close handles to avoid leaks.
		end
	end)
end)
print("TCP echo-server listening on port: " .. server:getsockname().port)
