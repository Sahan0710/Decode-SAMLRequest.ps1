param (
    [string]$url = "https://www.myidp.ibm.com/isam/sps/saml20idp/saml20/login?SAMLRequest=fVNNj9owED3vv7B8J%2FYGWCqLIKVBVZG2LYK0h14qxx4WS%2F5IPc6G%2FfdVAqw4dLlZfu%2FNvHkeL1E624qyS0e%2Fg78dYCInZz2KEShoF70IEg0KLx2gSErsy2%2FPIs%2B4aGNIQQVLbyT3FRIRYjLBU7JZF%2FTPUzPP5RPMD%2Fl00ejpvDk0nJINYgcbj0n6VNCc57MJ%2FzSZ8prPRL4Qs%2FlvSrYxvBoN8bt0UNC9ca0FMvQhe4ivRsE7g5KH8tq2Ch47B%2FHC%2Bbl7LugxpVYwZoOS9hgwiQVfcDbMwhADfVgDJuPlID%2BTUTDW933m3oxuM9O4TAXHDErHsMVRmXOj28uJ2fBi%2FOh4TOuz8dr4l%2FtBNWcSiq91vZ1sf%2BxrSn5BxNFEnnG6Wg7VxRhVXA2l4CSHEAS2S3aLLc9PPAS1WW%2BDNeqNfAnRyfSxhcfscbwxenIYqQKcNLbUOgIiJaW1oa8iyAQFTbEDyq59LlsEetypKvgEp0Sq4FoZDQ724SRVug5wy6qsRNzBYXV3hZRQAw9QbCViH6IekgWVQNdRemxDTJcE%2Flv8jH1g9B29%2FRGrfw%3D%3D&SigAlg=http%3A%2F%2Fwww.w3.org%2F2001%2F04%2Fxmldsig-more%23rsa-sha256&Signature=c2mf4ipBzOAn5oBmARVr%2BJ7YMBW3eAlJHtFtdEG%2Brz85Q2eQUUYu29maeb0EYgAq2Mf1WaXmFibyEAM91bhVc6b9TN%2BlOyPkuiqL5Du2v8qhjdZGs9mxy%2FqeaNhHwt6kRi89BVLbpDmnqXvjTwagdMSnxxOiM6eVFbU3X6xO3QCzJBcSQAyoioVVQVBspMDUjIK3RJ6Q%2FvfvNTaUXOcRfOUlWeSW7jyZgUvHUPDYb2Q1B0cOQcKf6paxVL%2F8UJX37xSPu9WeVGI%2B%2Bz%2FEcleavGMG49GI3GwE%2FodbsM%2BOvt7fdBh6uyeYdXxV5klswuG9gIqnwKdaB7vKJ1QafBuqCA%3D%3D"
)

# Extract the SAMLRequest part from the URL
$samlRequest = $url -replace '^.*SAMLRequest=([^&]+).*$', '$1'

# Step 1: Decode the URL-encoded SAMLRequest
$samlRequestDecoded = [System.Uri]::UnescapeDataString($samlRequest)

# Step 2: Base64 decode the SAMLRequest
$samlRequestBytes = [System.Convert]::FromBase64String($samlRequestDecoded)

# Step 3: Decompress the DEFLATE-compressed byte array using a different approach
$samlRequestStream = New-Object IO.MemoryStream
$samlRequestStream.Write($samlRequestBytes, 0, $samlRequestBytes.Length)
$samlRequestStream.Position = 0  # Reset position to the start of the stream
$decompressedStream = New-Object IO.Compression.DeflateStream($samlRequestStream, [IO.Compression.CompressionMode]::Decompress)
$streamReader = New-Object IO.StreamReader($decompressedStream, [System.Text.Encoding]::UTF8)
$samlRequestXml = $streamReader.ReadToEnd()

# Output the XML
Write-Output $samlRequestXml

#https://www.myidp.ibm.com/isam/sps/saml20idp/saml20/login?SAMLRequest=fVNNj9owED3vv7B8Jw5ZECuLIKVBVZG2LYK0h14qxx4WS%2F5IPc6G%2FfeVA6w47HKz%2FN6befM8XqKwpuNVH49uB%2F96wEhO1jjkI1DSPjjuBWrkTlhAHiXfV9%2BfeZHlvAs%2BeukNvZHcVwhECFF7R8lmXdK%2F%2BUw9znN5mC3aYjovFm3x2FKyQexh4zAKF0ta5MVskj9Niqcmn%2FPZlBfzP5Rsg3%2FVCsIPYaGke207AyT1IXsIr1rCO4OSh%2BratvYOewvhwvm1ey7pMcaOM2a8FOboMfJFvshZmoUhevqwBozaiSQ%2Fk5EzNgxDZt%2B06jLd2kx6yzQKy7DDUVnkWnWXEzP%2BRbvR8ZjWF%2B2Udi%2F3g2rPJOTfmmY72f7cN5T8hoCjiSLL6WqZqvMxqrBKpeAkUggcuyW7xZbnJ05BbdZbb7R8I199sCJ%2BbmGaTccbrSaHkcrBCm0qpQIgUlIZ44c6gIhQ0hh6oOza57JFoMadqr2LcIqk9rYTQWOyDych43WAW1ZtBOIODqu7KyS5TDxAvhWIgw8qJQsygmqCcNj5EC8JfFj8jH1i9B29%2FRGr%2Fw%3D%3D

#https://uatisvaint.combank.net/isam/sps/isva_scrm/saml20/login?SAMLRequest=lVPLjtowFN3zFSh7cAivYEGkFPpAohBB2kU3I8e5zFh17NTXmWH%2Bvs5jCq1apHoT%2Bfqe43OOb5bIClnSuLJP6gg%2FKkDb67t1KaRC2hyuvMooqhkKpIoVgNRyeoo%2F72gw9GlptNVcS%2B8P2H0UQwRjhVYtbLtZeYf9%2B93h43b%2FMF6wDGbzEMCfLhbhJGMzPp%2F483DqhxBk4Xk0ms9gzFroVzDoeFaeo%2FV6LRtiBVuFlinr6n4wGfjhIAhTf0bHPp2G31roxpkVitkG%2FmRtiZSQyu3xmQllh1wXGVPfhwosEc4TwRJJffiA3Lidcxn4ROpH0dlIuizeCZUL9Xg%2FgqxtQvopTZNBcjilLUn8Fs1aK6wKMCcwz4LDl%2BPuqtLd74SyvBDqVmZcCoKoW01RQ7esZdImEhP9B3xJboFXqpLunZXtJtFS8NemXq8P2hTM%2FtvxaDhqKiIfnJtWCgUTMs5zA4jeL55YSv2yNsAsrDxrKvD65LfbuyGFvBlZl5GFi%2B2vdVEyI7B%2BSbgwbjv31wRu29fSzd8RztHdEeWU132unLjPizZ5%2Fb7A3d2pYQpLbWyX0l%2FJW9Xkjuyo93Z8%2B%2F9FPwE%3D&RelayState=https%3A%2F%2Fcrmuatadmin.combank.net%2FApi%2Flogo


