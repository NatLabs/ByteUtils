import Iter "mo:core@2.4/Iter";
import Debug "mo:core@2.4/Debug";
import Nat "mo:core@2.4/Nat";
import Nat64 "mo:core@2.4/Nat64";
import List "mo:core@2.4/List";
import Runtime "mo:core@2.4/Runtime";

import Bench "mo:bench";
import Fuzz "mo:fuzz";

import ByteUtils "../src";

module {
    public func init() : Bench.Bench {
        let bench = Bench.Bench();

        bench.name("ByteUtils library Benchmarks: Little Endian Conversions");
        bench.description("Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions");

        bench.cols(["Type to Bytes", "Bytes to Type"]);
        bench.rows(["Nat8", "Nat16", "Nat32", "Nat64", "Int8", "Int16", "Int32", "Int64", "Float", "LEB128_64", "SLEB128_64"]);

        func xorshift128plus(seed : Nat) : { next() : Nat } {
            var state0 : Nat64 = Nat64.fromNat(seed);
            var state1 : Nat64 = Nat64.fromNat(seed + 1);
            if (state0 == 0) state0 := 1;
            if (state1 == 0) state1 := 2;

            {
                next = func() : Nat {
                    var s1 = state0;
                    let s0 = state1;
                    state0 := s0;
                    s1 ^= s1 << 23 : Nat64;
                    state1 := s1 ^ s0 ^ (s1 >> 18 : Nat64) ^ (s0 >> 5 : Nat64);
                    Nat64.toNat(state1 +% s0); // Use wrapping addition
                };
            };
        };

        let fuzz = Fuzz.create(xorshift128plus(0xdeadbeef));

        let nat8s = List.empty<Nat8>();
        let nat16s = List.empty<Nat16>();
        let nat32s = List.empty<Nat32>();
        let nat64s = List.empty<Nat64>();
        let floats = List.empty<Float>();
        let int8s = List.empty<Int8>();
        let int16s = List.empty<Int16>();
        let int32s = List.empty<Int32>();
        let int64s = List.empty<Int64>();
        let leb64s = List.empty<Nat64>();
        let sleb64s = List.empty<Int64>();

        for (i in Nat.rangeInclusive(0, 9_999)) {
            List.add(nat8s, fuzz.nat8.random());
            List.add(nat16s, fuzz.nat16.random());
            List.add(nat32s, fuzz.nat32.random());
            List.add(nat64s, fuzz.nat64.random());
            List.add(floats, fuzz.float.random());
            List.add(int8s, fuzz.int8.random());
            List.add(int16s, fuzz.int16.random());
            List.add(int32s, fuzz.int32.random());
            List.add(int64s, fuzz.int64.random());
            List.add(leb64s, fuzz.nat64.random());
            List.add(sleb64s, fuzz.int64.random());
        };

        // Add byte array test data
        let nat8Bytes = List.empty<[Nat8]>();
        let nat16Bytes = List.empty<[Nat8]>();
        let nat32Bytes = List.empty<[Nat8]>();
        let nat64Bytes = List.empty<[Nat8]>();
        let floatBytes = List.empty<[Nat8]>();
        let int8Bytes = List.empty<[Nat8]>();
        let int16Bytes = List.empty<[Nat8]>();
        let int32Bytes = List.empty<[Nat8]>();
        let int64Bytes = List.empty<[Nat8]>();
        let leb64Bytes = List.empty<[Nat8]>();
        let sleb64Bytes = List.empty<[Nat8]>();

        for (i in Nat.rangeInclusive(0, 9_999)) {
            List.add(nat8Bytes, ByteUtils.LittleEndian.fromNat8(fuzz.nat8.random()));
            List.add(nat16Bytes, ByteUtils.LittleEndian.fromNat16(fuzz.nat16.random()));
            List.add(nat32Bytes, ByteUtils.LittleEndian.fromNat32(fuzz.nat32.random()));
            List.add(nat64Bytes, ByteUtils.LittleEndian.fromNat64(fuzz.nat64.random()));
            List.add(floatBytes, ByteUtils.LittleEndian.fromFloat(fuzz.float.random()));
            List.add(int8Bytes, ByteUtils.LittleEndian.fromInt8(fuzz.int8.random()));
            List.add(int16Bytes, ByteUtils.LittleEndian.fromInt16(fuzz.int16.random()));
            List.add(int32Bytes, ByteUtils.LittleEndian.fromInt32(fuzz.int32.random()));
            List.add(int64Bytes, ByteUtils.LittleEndian.fromInt64(fuzz.int64.random()));
            List.add(leb64Bytes, ByteUtils.toLEB128_64(fuzz.nat64.random()));
            List.add(sleb64Bytes, ByteUtils.toSLEB128_64(fuzz.int64.random()));
        };

        bench.runner(
            func(row, col) = switch (col, row) {

                case ("Type to Bytes", "Nat8") {
                    for (nat8 in List.values(nat8s)) {
                        ignore ByteUtils.LittleEndian.fromNat8(nat8);
                    };
                };

                case ("Bytes to Type", "Nat8") {
                    for (bytes in List.values(nat8Bytes)) {
                        ignore ByteUtils.LittleEndian.toNat8(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Nat16") {
                    for (nat16 in List.values(nat16s)) {
                        ignore ByteUtils.LittleEndian.fromNat16(nat16);
                    };
                };

                case ("Bytes to Type", "Nat16") {
                    for (bytes in List.values(nat16Bytes)) {
                        ignore ByteUtils.LittleEndian.toNat16(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Nat32") {
                    for (nat32 in List.values(nat32s)) {
                        ignore ByteUtils.LittleEndian.fromNat32(nat32);
                    };
                };

                case ("Bytes to Type", "Nat32") {
                    for (bytes in List.values(nat32Bytes)) {
                        ignore ByteUtils.LittleEndian.toNat32(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Nat64") {
                    for (nat64 in List.values(nat64s)) {
                        ignore ByteUtils.LittleEndian.fromNat64(nat64);
                    };
                };

                case ("Bytes to Type", "Nat64") {
                    for (bytes in List.values(nat64Bytes)) {
                        ignore ByteUtils.LittleEndian.toNat64(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Int8") {
                    for (int8 in List.values(int8s)) {
                        ignore ByteUtils.LittleEndian.fromInt8(int8);
                    };
                };

                case ("Bytes to Type", "Int8") {
                    for (bytes in List.values(int8Bytes)) {
                        ignore ByteUtils.LittleEndian.toInt8(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Int16") {
                    for (int16 in List.values(int16s)) {
                        ignore ByteUtils.LittleEndian.fromInt16(int16);
                    };
                };

                case ("Bytes to Type", "Int16") {
                    for (bytes in List.values(int16Bytes)) {
                        ignore ByteUtils.LittleEndian.toInt16(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Int32") {
                    for (int32 in List.values(int32s)) {
                        ignore ByteUtils.LittleEndian.fromInt32(int32);
                    };
                };

                case ("Bytes to Type", "Int32") {
                    for (bytes in List.values(int32Bytes)) {
                        ignore ByteUtils.LittleEndian.toInt32(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Int64") {
                    for (int64 in List.values(int64s)) {
                        ignore ByteUtils.LittleEndian.fromInt64(int64);
                    };
                };

                case ("Bytes to Type", "Int64") {
                    for (bytes in List.values(int64Bytes)) {
                        ignore ByteUtils.LittleEndian.toInt64(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Float") {
                    for (float in List.values(floats)) {
                        ignore ByteUtils.LittleEndian.fromFloat(float);
                    };
                };

                case ("Bytes to Type", "Float") {
                    for (bytes in List.values(floatBytes)) {
                        ignore ByteUtils.LittleEndian.toFloat(bytes.vals());
                    };
                };

                case ("Type to Bytes", "LEB128_64") {
                    for (nat64 in List.values(leb64s)) {
                        ignore ByteUtils.toLEB128_64(nat64);
                    };
                };

                case ("Bytes to Type", "LEB128_64") {
                    for (bytes in List.values(leb64Bytes)) {
                        ignore ByteUtils.fromLEB128_64(bytes.vals());
                    };
                };

                case ("Type to Bytes", "SLEB128_64") {
                    for (int64 in List.values(sleb64s)) {
                        ignore ByteUtils.toSLEB128_64(int64);
                    };
                };

                case ("Bytes to Type", "SLEB128_64") {
                    for (bytes in List.values(sleb64Bytes)) {
                        ignore ByteUtils.fromSLEB128_64(bytes.vals());
                    };
                };

                case (_) {
                    Runtime.trap("Should be unreachable:\n row = \"" # debug_show row # "\" and col = \"" # debug_show col # "\"");
                };
            }
        );

        bench;
    };
};
