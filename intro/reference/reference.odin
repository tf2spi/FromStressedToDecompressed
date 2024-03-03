package intro_reference
import "core:fmt"
import "core:os"
import "core:io"
import "core:bufio"

run_byte: u8 : 0xff

main :: proc() {
	argv := os.args
	if len(argv) < 3 {
		fmt.printf("Usage: %s input output\n", argv[0])
		os.exit(2)
	}

	in_name, out_name := argv[1], argv[2]
	in_buf, success := os.read_entire_file_from_filename(in_name)
	if !success {
		fmt.printf("Failed to read input file '%s'! Does the file exist?\n", in_name)
		os.exit(1)
	}

	out_buf: [dynamic]u8
	last_byte, last_count := -1, u16(0)
	defer delete(out_buf)
	for i in 0..=len(in_buf) {
		if i == len(in_buf) || int(in_buf[i]) != last_byte || last_count == 0x100 {
			if last_count > 3 || last_byte == int(run_byte) {
				append(&out_buf, run_byte)
				append(&out_buf, u8(last_count - 1))
				append(&out_buf, u8(last_byte))
			} else {
				for i in 0..<last_count { append(&out_buf, u8(last_byte)) }
			}
			if i != len(in_buf) { last_byte = int(in_buf[i]) }
			last_count = 0
		}
		last_count += 1
	}

	success = os.write_entire_file(out_name, out_buf[:])
	if !success {
		fmt.printf("Failed to create output file '%s'!\n", out_name)
		os.exit(1)
	}
	fmt.printf("Compressed '%s' -> '%s' (%d -> %d bytes)\n", in_name, out_name, len(in_buf), len(out_buf))
}
