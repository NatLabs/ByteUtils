import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Prelude "mo:base/Prelude";
import Buffer "mo:base/Buffer";

import Bench "mo:bench";
import Fuzz "mo:fuzz";

import ByteUtils "../src";

module {
    public func init() : Bench.Bench {
        let bench = Bench.Bench();

        bench.name("ByteUtils library Benchmarks: Conversion from number to bytes");
        bench.description("Benchmarking the performance with 10k calls");

        bench.rows(["LittleEndian", "BigEndian"]);
        bench.cols(["fromNat8()", "fromNat16()", "fromNat32()", "fromNat64()", "fromFloat()"]);

        let fuzz = Fuzz.Fuzz();

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

        bench.runner(
            func(row, col) = switch (row, col) {

                case ("BigEndian", "fromNat8()") {

                    for (nat8 in nat8s.vals()) {
                        ignore ByteUtils.BigEndian.fromNat8(nat8);
                    };
                };

                case ("BigEndian", "fromNat16()") {

                    for (nat16 in nat16s.vals()) {
                        ignore ByteUtils.BigEndian.fromNat16(nat16);
                    };
                };

                case ("BigEndian", "fromNat32()") {

                    for (nat32 in nat32s.vals()) {
                        ignore ByteUtils.BigEndian.fromNat32(nat32);
                    };
                };

                case ("BigEndian", "fromNat64()") {

                    for (nat64 in nat64s.vals()) {
                        ignore ByteUtils.BigEndian.fromNat64(nat64);
                    };
                };

                case ("BigEndian", "fromFloat()") {
                    for (float in floats.vals()) {
                        ignore ByteUtils.BigEndian.fromFloat64(float);
                    };
                };

                case ("LittleEndian", "fromNat8()") {

                    for (nat8 in nat8s.vals()) {
                        ignore ByteUtils.LittleEndian.fromNat8(nat8);
                    };
                };

                case ("LittleEndian", "fromNat16()") {

                    for (nat16 in nat16s.vals()) {
                        ignore ByteUtils.LittleEndian.fromNat16(nat16);
                    };
                };

                case ("LittleEndian", "fromNat32()") {

                    for (nat32 in nat32s.vals()) {
                        ignore ByteUtils.LittleEndian.fromNat32(nat32);
                    };
                };

                case ("LittleEndian", "fromNat64()") {

                    for (nat64 in nat64s.vals()) {
                        ignore ByteUtils.LittleEndian.fromNat64(nat64);
                    };
                };

                case ("LittleEndian", "fromFloat()") {
                    for (float in floats.vals()) {
                        ignore ByteUtils.LittleEndian.fromFloat64(float);
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
