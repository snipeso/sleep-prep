

function ratio = gpt_compression(your_data)

original = uint8(your_data);  % Your data as a byte stream
compressed = zlibencode(original);  % Built-in function
ratio = numel(compressed) / numel(original);  % Compression ratio