import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Prelude "mo:base/Prelude";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";

import Bench "mo:bench";
import Fuzz "mo:fuzz";

import ByteUtils "../src";

module {
    public func init() : Bench.Bench {
        let bench = Bench.Bench();

        bench.name("ByteUtils library Benchmarks: Conversion from bytes to number");
        bench.description("Benchmarking the performance with 10k calls");

        bench.rows(["LittleEndian", "BigEndian"]);
        bench.cols(["toNat8()", "toNat16()", "toNat32()", "toNat64()", "toFloat()"]);

        let fuzz = Fuzz.Fuzz();

        // Generate random numbers first
        let nat8s = Buffer.Buffer<Nat8>(10_000);
        let nat16s = Buffer.Buffer<Nat16>(10_000);
        let nat32s = Buffer.Buffer<Nat32>(10_000);
        let nat64s = Buffer.Buffer<Nat64>(10_000);
        let floats = Buffer.Buffer<Float>(10_000);

        for (i in Iter.range(0, 9_999)) {
            nat8s.add(fuzz.nat8.random());
            nat16s.add(fuzz.nat16.random());
            nat32s.add(fuzz.nat32.random());
            nat64s.add(fuzz.nat64.random());
            floats.add(fuzz.float.random());
        };

        // Pre-generate all the byte arrays to ensure we're only measuring conversion time
        let bytesNat8_LE = Array.map<Nat8, [Nat8]>(Buffer.toArray(nat8s), ByteUtils.LittleEndian.fromNat8);
        let bytesNat16_LE = Array.map<Nat16, [Nat8]>(Buffer.toArray(nat16s), ByteUtils.LittleEndian.fromNat16);
        let bytesNat32_LE = Array.map<Nat32, [Nat8]>(Buffer.toArray(nat32s), ByteUtils.LittleEndian.fromNat32);
        let bytesNat64_LE = Array.map<Nat64, [Nat8]>(Buffer.toArray(nat64s), ByteUtils.LittleEndian.fromNat64);
        let bytesFloat_LE = Array.map<Float, [Nat8]>(Buffer.toArray(floats), ByteUtils.LittleEndian.fromFloat64);

        let bytesNat8_BE = Array.map<Nat8, [Nat8]>(Buffer.toArray(nat8s), ByteUtils.BigEndian.fromNat8);
        let bytesNat16_BE = Array.map<Nat16, [Nat8]>(Buffer.toArray(nat16s), ByteUtils.BigEndian.fromNat16);
        let bytesNat32_BE = Array.map<Nat32, [Nat8]>(Buffer.toArray(nat32s), ByteUtils.BigEndian.fromNat32);
        let bytesNat64_BE = Array.map<Nat64, [Nat8]>(Buffer.toArray(nat64s), ByteUtils.BigEndian.fromNat64);
        let bytesFloat_BE = Array.map<Float, [Nat8]>(Buffer.toArray(floats), ByteUtils.BigEndian.fromFloat64);

        bench.runner(
            func(row, col) = switch (row, col) {
                case ("BigEndian", "toNat8()") {
                    for (bytes in bytesNat8_BE.vals()) {
                        ignore ByteUtils.BigEndian.toNat8(bytes.vals());
                    };
                };

                case ("BigEndian", "toNat16()") {
                    for (bytes in bytesNat16_BE.vals()) {
                        ignore ByteUtils.BigEndian.toNat16(bytes.vals());
                    };
                };

                case ("BigEndian", "toNat32()") {
                    for (bytes in bytesNat32_BE.vals()) {
                        ignore ByteUtils.BigEndian.toNat32(bytes.vals());
                    };
                };

                case ("BigEndian", "toNat64()") {
                    for (bytes in bytesNat64_BE.vals()) {
                        ignore ByteUtils.BigEndian.toNat64(bytes.vals());
                    };
                };

                case ("BigEndian", "toFloat()") {
                    for (bytes in bytesFloat_BE.vals()) {
                        ignore ByteUtils.BigEndian.toFloat64(bytes.vals());
                    };
                };

                case ("LittleEndian", "toNat8()") {
                    for (bytes in bytesNat8_LE.vals()) {
                        ignore ByteUtils.LittleEndian.toNat8(bytes.vals());
                    };
                };

                case ("LittleEndian", "toNat16()") {
                    for (bytes in bytesNat16_LE.vals()) {
                        ignore ByteUtils.LittleEndian.toNat16(bytes.vals());
                    };
                };

                case ("LittleEndian", "toNat32()") {
                    for (bytes in bytesNat32_LE.vals()) {
                        ignore ByteUtils.LittleEndian.toNat32(bytes.vals());
                    };
                };

                case ("LittleEndian", "toNat64()") {
                    for (bytes in bytesNat64_LE.vals()) {
                        ignore ByteUtils.LittleEndian.toNat64(bytes.vals());
                    };
                };

                case ("LittleEndian", "toFloat()") {
                    for (bytes in bytesFloat_LE.vals()) {
                        ignore ByteUtils.LittleEndian.toFloat64(bytes.vals());
                    };
                };

                case (_) {
                    Debug.trap("Should be unreachable:\n row = \"" # debug_show row # "\" and col = \"" # debug_show col # "\"");
                };
            }
        );

        bench;
    };
};
