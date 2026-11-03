from pathlib import Path
import struct

root = Path(__file__).resolve().parents[1]
for name in ("zil.wav", "ton-kisa.wav", "ton-uzun.wav", "istiklal-marsi.wav"):
    data = (root / "resources" / name).read_bytes()
    assert data[:4] == b"RIFF" and data[8:12] == b"WAVE", name
    fmt = data.find(b"fmt ")
    assert fmt >= 0, name
    format_tag, channels, rate = struct.unpack_from("<HHI", data, fmt + 8)
    bits = struct.unpack_from("<H", data, fmt + 22)[0]
    assert format_tag == 1 and channels in (1, 2) and rate > 0 and bits == 16, name
    assert b"data" in data, name
print("4 WAV assets: valid PCM 16-bit")
