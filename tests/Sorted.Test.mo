// @testmode wasi
import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Int8 "mo:base/Int8";
import Iter "mo:base/Iter";
import Int32 "mo:base/Int32";
import Int16 "mo:base/Int16";
import Int64 "mo:base/Int64";
import Float "mo:base/Float";
import Nat64 "mo:base/Nat64";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Bool "mo:base/Bool";

import { test; suite } "mo:test";
import Itertools "mo:itertools/Iter";
import BpTree "mo:augmented-btrees/BpTree";
import Cmp "mo:augmented-btrees/Cmp";

import Fuzz "mo:fuzz";

import ByteUtils "../src";

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
let limit = 1_000;

// Test data generation
type TestData = {
    nat8 : Nat8;
    nat16 : Nat16;
    nat32 : Nat32;
    nat64 : Nat64;
    int8 : Int8;
    int16 : Int16;
    int32 : Int32;
    int64 : Int64;
    float : Float;
    bool : Bool;
    text : Text;
};

let inputs = Buffer.Buffer<TestData>(limit);

let sorted_nat8s = BpTree.new<Nat8, Nat>(null);
let sorted_nat16s = BpTree.new<Nat16, Nat>(null);
let sorted_nat32s = BpTree.new<Nat32, Nat>(null);
let sorted_nat64s = BpTree.new<Nat64, Nat>(null);
let sorted_int8s = BpTree.new<Int8, Nat>(null);
let sorted_int16s = BpTree.new<Int16, Nat>(null);
let sorted_int32s = BpTree.new<Int32, Nat>(null);
let sorted_int64s = BpTree.new<Int64, Nat>(null);
let sorted_floats = BpTree.new<Float, Nat>(null);

for (i in Iter.range(0, limit - 1)) {
    let record : TestData = {
        nat8 = fuzz.nat8.random();
        nat16 = fuzz.nat16.random();
        nat32 = fuzz.nat32.random();
        nat64 = fuzz.nat64.random();
        int8 = fuzz.int8.random();
        int16 = fuzz.int16.random();
        int32 = fuzz.int32.random();
        int64 = fuzz.int64.random();
        float = fuzz.float.random();
        bool = fuzz.bool.random();
        text = fuzz.text.randomAlphanumeric(fuzz.nat.randomRange(1, 50));
    };
    inputs.add(record);

    ignore BpTree.insert(sorted_nat8s, Cmp.Nat8, record.nat8, i);
    ignore BpTree.insert(sorted_nat16s, Cmp.Nat16, record.nat16, i);
    ignore BpTree.insert(sorted_nat32s, Cmp.Nat32, record.nat32, i);
    ignore BpTree.insert(sorted_nat64s, Cmp.Nat64, record.nat64, i);
    ignore BpTree.insert(sorted_int8s, Cmp.Int8, record.int8, i);
    ignore BpTree.insert(sorted_int16s, Cmp.Int16, record.int16, i);
    ignore BpTree.insert(sorted_int32s, Cmp.Int32, record.int32, i);
    ignore BpTree.insert(sorted_int64s, Cmp.Int64, record.int64, i);
    ignore BpTree.insert(sorted_floats, Cmp.Float, record.float, i);

};

suite(
    "ByteUtils Sorted: sortable encodings maintain correct order",
    func() {
        test(
            "Nat8 sortable encoding",
            func() {

                let encoded_nat8s = BpTree.new<Blob, Nat>(null);

                for ((i, r) in Itertools.enumerate(inputs.vals())) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromNat8(r.nat8));
                    ignore BpTree.insert(encoded_nat8s, Cmp.Blob, encoded, i);
                };

                // Verify same ordering
                assert Itertools.equal(
                    BpTree.vals(sorted_nat8s),
                    BpTree.vals(encoded_nat8s),
                    Nat.equal,
                );

                // Verify round-trip conversion
                assert Itertools.equal(
                    BpTree.keys(sorted_nat8s),
                    Iter.map<Blob, Nat8>(
                        BpTree.keys(encoded_nat8s),
                        func(b : Blob) : Nat8 {
                            ByteUtils.Sorted.toNat8(b.vals());
                        },
                    ),
                    Nat8.equal,
                );
            },
        );

        test(
            "Nat16 sortable encoding",
            func() {

                let encoded_nat16s = BpTree.new<Blob, Nat>(null);

                for ((i, r) in Itertools.enumerate(inputs.vals())) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromNat16(r.nat16));
                    ignore BpTree.insert(encoded_nat16s, Cmp.Blob, encoded, i);
                };

                assert Itertools.equal(
                    BpTree.vals(sorted_nat16s),
                    BpTree.vals(encoded_nat16s),
                    Nat.equal,
                );

                assert Itertools.equal(
                    BpTree.keys(sorted_nat16s),
                    Iter.map<Blob, Nat16>(
                        BpTree.keys(encoded_nat16s),
                        func(b : Blob) : Nat16 {
                            ByteUtils.Sorted.toNat16(b.vals());
                        },
                    ),
                    Nat16.equal,
                );
            },
        );

        test(
            "Nat32 sortable encoding",
            func() {
                let encoded_nat32s = BpTree.new<Blob, Nat>(null);

                for ((i, r) in Itertools.enumerate(inputs.vals())) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromNat32(r.nat32));
                    ignore BpTree.insert(encoded_nat32s, Cmp.Blob, encoded, i);
                };

                assert Itertools.equal(
                    BpTree.vals(sorted_nat32s),
                    BpTree.vals(encoded_nat32s),
                    Nat.equal,
                );

                assert Itertools.equal(
                    BpTree.keys(sorted_nat32s),
                    Iter.map<Blob, Nat32>(
                        BpTree.keys(encoded_nat32s),
                        func(b : Blob) : Nat32 {
                            ByteUtils.Sorted.toNat32(b.vals());
                        },
                    ),
                    Nat32.equal,
                );
            },
        );

        test(
            "Nat64 sortable encoding",
            func() {
                let encoded_nat64s = BpTree.new<Blob, Nat>(null);

                for ((i, r) in Itertools.enumerate(inputs.vals())) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromNat64(r.nat64));
                    ignore BpTree.insert(encoded_nat64s, Cmp.Blob, encoded, i);
                };

                assert Itertools.equal(
                    BpTree.vals(sorted_nat64s),
                    BpTree.vals(encoded_nat64s),
                    Nat.equal,
                );

                assert Itertools.equal(
                    BpTree.keys(sorted_nat64s),
                    Iter.map<Blob, Nat64>(
                        BpTree.keys(encoded_nat64s),
                        func(b : Blob) : Nat64 {
                            ByteUtils.Sorted.toNat64(b.vals());
                        },
                    ),
                    Nat64.equal,
                );
            },
        );

        test(
            "Int8 sortable encoding",
            func() {
                let encoded_int8s = BpTree.new<Blob, Nat>(null);

                // Test full range of Int8 values
                for ((i, r) in Itertools.enumerate(inputs.vals())) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromInt8(r.int8));
                    ignore BpTree.insert(encoded_int8s, Cmp.Blob, encoded, i);
                };

                assert Itertools.equal(
                    BpTree.vals(sorted_int8s),
                    BpTree.vals(encoded_int8s),
                    Nat.equal,
                );

                // Verify negative values sort before positive values
                let neg_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt8(-1));
                let zero_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt8(0));
                let pos_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt8(1));

                assert neg_encoded < zero_encoded;
                assert zero_encoded < pos_encoded;

                assert Itertools.equal(
                    BpTree.keys(sorted_int8s),
                    Iter.map<Blob, Int8>(
                        BpTree.keys(encoded_int8s),
                        func(b : Blob) : Int8 {
                            ByteUtils.Sorted.toInt8(b.vals());
                        },
                    ),
                    Int8.equal,
                );
            },
        );

        test(
            "Int16 sortable encoding",
            func() {
                let encoded_int16s = BpTree.new<Blob, Nat>(null);

                for ((i, r) in Itertools.enumerate(inputs.vals())) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromInt16(r.int16));
                    ignore BpTree.insert(encoded_int16s, Cmp.Blob, encoded, i);
                };

                assert Itertools.equal(
                    BpTree.vals(sorted_int16s),
                    BpTree.vals(encoded_int16s),
                    Nat.equal,
                );

                // Test boundary values
                let min_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt16(Int16.minimumValue));
                let zero_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt16(0));
                let max_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt16(Int16.maximumValue));

                assert min_encoded < zero_encoded;
                assert zero_encoded < max_encoded;

                assert Itertools.equal(
                    BpTree.keys(sorted_int16s),
                    Iter.map<Blob, Int16>(
                        BpTree.keys(encoded_int16s),
                        func(b : Blob) : Int16 {
                            ByteUtils.Sorted.toInt16(b.vals());
                        },
                    ),
                    Int16.equal,
                );
            },
        );

        test(
            "Int32 sortable encoding",
            func() {
                let encoded_int32s = BpTree.new<Blob, Nat>(null);

                for ((i, r) in Itertools.enumerate(inputs.vals())) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromInt32(r.int32));
                    ignore BpTree.insert(encoded_int32s, Cmp.Blob, encoded, i);
                };

                assert Itertools.equal(
                    BpTree.vals(sorted_int32s),
                    BpTree.vals(encoded_int32s),
                    Nat.equal,
                );

                // Test boundary values
                let min_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt32(Int32.minimumValue));
                let zero_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt32(0));
                let max_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt32(Int32.maximumValue));

                assert min_encoded < zero_encoded;
                assert zero_encoded < max_encoded;

                assert Itertools.equal(
                    BpTree.keys(sorted_int32s),
                    Iter.map<Blob, Int32>(
                        BpTree.keys(encoded_int32s),
                        func(b : Blob) : Int32 {
                            ByteUtils.Sorted.toInt32(b.vals());
                        },
                    ),
                    Int32.equal,
                );
            },
        );

        test(
            "Int64 sortable encoding",
            func() {
                let encoded_int64s = BpTree.new<Blob, Nat>(null);

                for ((i, r) in Itertools.enumerate(inputs.vals())) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromInt64(r.int64));
                    ignore BpTree.insert(encoded_int64s, Cmp.Blob, encoded, i);
                };

                assert Itertools.equal(
                    BpTree.vals(sorted_int64s),
                    BpTree.vals(encoded_int64s),
                    Nat.equal,
                );

                // Test boundary values
                let min_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt64(Int64.minimumValue));
                let zero_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt64(0));
                let max_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt64(Int64.maximumValue));

                assert min_encoded < zero_encoded;
                assert zero_encoded < max_encoded;

                assert Itertools.equal(
                    BpTree.keys(sorted_int64s),
                    Iter.map<Blob, Int64>(
                        BpTree.keys(encoded_int64s),
                        func(b : Blob) : Int64 {
                            ByteUtils.Sorted.toInt64(b.vals());
                        },
                    ),
                    Int64.equal,
                );
            },
        );

        test(
            "Float sortable encoding",
            func() {
                let encoded_floats = BpTree.new<Blob, Nat>(null);

                for ((i, r) in Itertools.enumerate(inputs.vals())) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromFloat(r.float));
                    ignore BpTree.insert(encoded_floats, Cmp.Blob, encoded, i);
                };

                assert Itertools.equal(
                    BpTree.vals(sorted_floats),
                    BpTree.vals(encoded_floats),
                    Nat.equal,
                );

                // Test that negative floats sort before positive floats
                let neg_encoded = Blob.fromArray(ByteUtils.Sorted.fromFloat(-1.0));
                let zero_encoded = Blob.fromArray(ByteUtils.Sorted.fromFloat(0.0));
                let pos_encoded = Blob.fromArray(ByteUtils.Sorted.fromFloat(1.0));

                assert neg_encoded < zero_encoded;
                assert zero_encoded < pos_encoded;

                assert Itertools.equal(
                    BpTree.keys(sorted_floats),
                    Iter.map<Blob, Float>(
                        BpTree.keys(encoded_floats),
                        func(b : Blob) : Float {
                            ByteUtils.Sorted.toFloat(b.vals());
                        },
                    ),
                    func(a : Float, b : Float) : Bool {
                        // For floating-point values, we need to account for small precision differences
                        let epsilon : Float = 0.0000001;
                        Float.equalWithin(a, b, epsilon);
                    },
                );
            },
        );

    },
);
