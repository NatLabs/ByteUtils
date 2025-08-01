import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Prelude "mo:base/Prelude";
import Buffer "mo:base/Buffer";
import Nat64 "mo:base/Nat64";

import Bench "mo:bench";
import Fuzz "mo:fuzz";

import ByteUtils "../src";

module {
    public func init() : Bench.Bench {
        let bench = Bench.Bench();

        bench.name("ByteUtils library Benchmarks: Sorted Encodings");
        bench.description("Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions using sortable encodings");

        bench.cols(["Type to Bytes", "Bytes to Type"]);
        bench.rows(["Nat8", "Nat16", "Nat32", "Nat64", "Int8", "Int16", "Int32", "Int64", "Float"]);

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

        let nat8s = Buffer.Buffer<Nat8>(10_000);
        let nat16s = Buffer.Buffer<Nat16>(10_000);
        let nat32s = Buffer.Buffer<Nat32>(10_000);
        let nat64s = Buffer.Buffer<Nat64>(10_000);
        let floats = Buffer.Buffer<Float>(10_000);
        let int8s = Buffer.Buffer<Int8>(10_000);
        let int16s = Buffer.Buffer<Int16>(10_000);
        let int32s = Buffer.Buffer<Int32>(10_000);
        let int64s = Buffer.Buffer<Int64>(10_000);

        for (i in Iter.range(0, 9_999)) {
            nat8s.add(fuzz.nat8.random());
            nat16s.add(fuzz.nat16.random());
            nat32s.add(fuzz.nat32.random());
            nat64s.add(fuzz.nat64.random());
            floats.add(fuzz.float.random());
            int8s.add(fuzz.int8.random());
            int16s.add(fuzz.int16.random());
            int32s.add(fuzz.int32.random());
            int64s.add(fuzz.int64.random());
        };

        // Add byte array test data
        let nat8Bytes = Buffer.Buffer<[Nat8]>(10_000);
        let nat16Bytes = Buffer.Buffer<[Nat8]>(10_000);
        let nat32Bytes = Buffer.Buffer<[Nat8]>(10_000);
        let nat64Bytes = Buffer.Buffer<[Nat8]>(10_000);
        let floatBytes = Buffer.Buffer<[Nat8]>(10_000);
        let int8Bytes = Buffer.Buffer<[Nat8]>(10_000);
        let int16Bytes = Buffer.Buffer<[Nat8]>(10_000);
        let int32Bytes = Buffer.Buffer<[Nat8]>(10_000);
        let int64Bytes = Buffer.Buffer<[Nat8]>(10_000);

        for (i in Iter.range(0, 9_999)) {
            nat8Bytes.add(ByteUtils.Sorted.fromNat8(fuzz.nat8.random()));
            nat16Bytes.add(ByteUtils.Sorted.fromNat16(fuzz.nat16.random()));
            nat32Bytes.add(ByteUtils.Sorted.fromNat32(fuzz.nat32.random()));
            nat64Bytes.add(ByteUtils.Sorted.fromNat64(fuzz.nat64.random()));
            floatBytes.add(ByteUtils.Sorted.fromFloat(fuzz.float.random()));
            int8Bytes.add(ByteUtils.Sorted.fromInt8(fuzz.int8.random()));
            int16Bytes.add(ByteUtils.Sorted.fromInt16(fuzz.int16.random()));
            int32Bytes.add(ByteUtils.Sorted.fromInt32(fuzz.int32.random()));
            int64Bytes.add(ByteUtils.Sorted.fromInt64(fuzz.int64.random()));
        };

        bench.runner(
            func(row, col) = switch (col, row) {

                case ("Type to Bytes", "Nat8") {
                    for (nat8 in nat8s.vals()) {
                        ignore ByteUtils.Sorted.fromNat8(nat8);
                    };
                };

                case ("Bytes to Type", "Nat8") {
                    for (bytes in nat8Bytes.vals()) {
                        ignore ByteUtils.Sorted.toNat8(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Nat16") {
                    for (nat16 in nat16s.vals()) {
                        ignore ByteUtils.Sorted.fromNat16(nat16);
                    };
                };

                case ("Bytes to Type", "Nat16") {
                    for (bytes in nat16Bytes.vals()) {
                        ignore ByteUtils.Sorted.toNat16(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Nat32") {
                    for (nat32 in nat32s.vals()) {
                        ignore ByteUtils.Sorted.fromNat32(nat32);
                    };
                };

                case ("Bytes to Type", "Nat32") {
                    for (bytes in nat32Bytes.vals()) {
                        ignore ByteUtils.Sorted.toNat32(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Nat64") {
                    for (nat64 in nat64s.vals()) {
                        ignore ByteUtils.Sorted.fromNat64(nat64);
                    };
                };

                case ("Bytes to Type", "Nat64") {
                    for (bytes in nat64Bytes.vals()) {
                        ignore ByteUtils.Sorted.toNat64(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Int8") {
                    for (int8 in int8s.vals()) {
                        ignore ByteUtils.Sorted.fromInt8(int8);
                    };
                };

                case ("Bytes to Type", "Int8") {
                    for (bytes in int8Bytes.vals()) {
                        ignore ByteUtils.Sorted.toInt8(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Int16") {
                    for (int16 in int16s.vals()) {
                        ignore ByteUtils.Sorted.fromInt16(int16);
                    };
                };

                case ("Bytes to Type", "Int16") {
                    for (bytes in int16Bytes.vals()) {
                        ignore ByteUtils.Sorted.toInt16(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Int32") {
                    for (int32 in int32s.vals()) {
                        ignore ByteUtils.Sorted.fromInt32(int32);
                    };
                };

                case ("Bytes to Type", "Int32") {
                    for (bytes in int32Bytes.vals()) {
                        ignore ByteUtils.Sorted.toInt32(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Int64") {
                    for (int64 in int64s.vals()) {
                        ignore ByteUtils.Sorted.fromInt64(int64);
                    };
                };

                case ("Bytes to Type", "Int64") {
                    for (bytes in int64Bytes.vals()) {
                        ignore ByteUtils.Sorted.toInt64(bytes.vals());
                    };
                };

                case ("Type to Bytes", "Float") {
                    for (float in floats.vals()) {
                        ignore ByteUtils.Sorted.fromFloat(float);
                    };
                };

                case ("Bytes to Type", "Float") {
                    for (bytes in floatBytes.vals()) {
                        ignore ByteUtils.Sorted.toFloat(bytes.vals());
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
