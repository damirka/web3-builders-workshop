// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module samples::module_sample {

}






module samples::basics {

    /// Operations:
    /// - `&&` short-circuiting AND
    /// - `||` short-circuiting OR
    /// - `!` logical negation
    ///
    /// Notes:
    /// - `bool` is implicitly copyable
    fun boolean(): bool {
        let a = false;
        let b = true;

        let c = a == b;
        let d = a != b;
        let e = !c && d;

        e
    }










    /// Supported: u8, u16, u32, u64, u128, u256
    ///
    /// Operations (Arithmetic):
    /// - `+` addition
    /// - `-` subtraction
    /// - `*` multiplication
    /// - `%` modular division
    /// - `/` truncating division
    ///
    /// Operations (Bitwise):
    /// - `&` bitwise AND
    /// - `|` bitwise OR
    /// - `^` bitwise XOR
    ///
    /// Operations (Bit Shift):
    /// - `<<` left shift
    /// - `>>` right shift
    ///
    /// Operations (Comparison):
    /// - `==` equality
    /// - `!=` inequality
    /// - `<` less than
    /// - `<=` less than or equal to
    /// - `>` greater than
    /// - `>=` greater than or equal to
    ///
    /// Notes:
    /// - underscore prefix to ignore unused variable (omit warning)
    /// - all integers are implicitly copyable
    fun integers(): u128 {
        let _h = 0xBEEF;
        let a = 10;
        let _b = 10u8;
        let _c = 10u128;

        // type of a is now known
        let d: u8 = a;

        // `as` is used for casting
        let e = (d as u128) + 1000;

        // underscore is an allowed separator
        let f = 100_000_000_000 - e;

        f
    }









    /// Address represents a location (e.g. account, contract, etc.) on the blockchain.
    /// An address is typically a 32 byte (256 bit) value.
    ///
    /// Notes:
    /// - depending on the VM settings, address length can differ (16, 20, 32 etc)
    /// - `address` is implicitly copyable
    fun addresses(): address {
        let _std = @0x0000000000000000000000000000000000000000000000000000000000000000;
        let std = @std;

        let _sui = @sui;
        let _sui = @0x2;

        // specified in the Move.toml
        let _beep = @samples;

        std
    }








    /// Three slash comments are used for documentation.
    fun /* my favorite part */ comments /* can we do it anywhere */ () /* ...yeah */ {
        // two slash comments are also supported
    }









    /// "(almost) everything" is an expression; block is a sequence of expressions,
    /// expressions are separated by semicolons.
    fun expression_and_scope(): () {
        (); // empty expression
        {  }; // block expression
        { () }; // same as above

        // block expression can be used to create a new scope
        let _scoped = {
            true;
            false // last one wins
        };

        // variables are local to their scope
        let _ten = 10;
        let _twenty = {
            let ten = 20; // shadowing
            { { ten } }
        };

        let _ten = 5; // shadowing
        () // implicitly returned
    }








    /// `if` is an expression, it evaluates to the last expression in the block.
    /// If the value of the expression is assigned, both branches must have the
    /// same type; otherwise,
    fun if_expression(): bool {
        let _cond = if (10 < 100) { 10 } else { 100 };
        let cond = if ( if (10 > 5) true else false ) {
            10
        } else {
            100
        }; // semicolon sequences expressions

        // value is not used, else is optional
        if (false) {
            cond = 50;
        };

        // result of the expression is returned
        if (cond == 50) {
            true
        } else {
            false
        }
    }








    /// Notes:
    /// - `while` is an empty expression
    /// - `loop` is also an empty expression
    /// - `break` and `continue` do not require semicolon and treated as return
    /// for the current "loop block"
    fun loops(): u8 {

        let i = 10;
        while (i > 0) {
            i = i - 1;

            if (i == 5) {
                continue // no semi...; any code after this expression will not be reached
            }
        }; // semi!!!


        loop {
            i = i + 1;
            break
        };

        i
    }






    use std::vector;

    /// Notes:
    /// - vector is a built-in type, however, to work with the `vector`, the
    /// `std::vector` module must be imported.
    /// - for the literal / definition scenario, the `vector[...]` syntax is
    /// used.
    fun vectors(): vector<u8> {
        let hex_bytes = x"C0FFEE";
        let ascii_bytes = b"hello world";
        let literal: vector<u8> = vector[ 10, 20, 30 ];

        let sum = vector[
            vector::pop_back(&mut hex_bytes),
            vector::pop_back(&mut ascii_bytes),
            vector::pop_back(&mut literal)
        ];

        vector::append(&mut sum, vector[0, 1, 2]);
        vector::push_back(&mut sum, 3);

        sum
    }





    /// Struct can contain any number of fields, each field has a name and a type.
    /// All of the fields of the struct are private!
    struct Hero {
        name: vector<u8>,
        level: u8
    }

    /// Struct types can be packed, returned and used as arguments.
    fun new_hero(name: vector<u8>): Hero {
        Hero {
            name: name,
            level: 1
        }
    }

    /// Function that will always abort - Hero can not be ignored.
    fun delete_hero_fail(_hero: Hero) {
        abort 0
    }

    /// Unpacking is a "reverse-version" of the packing operation. Only module
    /// defining the struct can unpack it.
    fun delete_hero(hero: Hero) {
        let Hero { name: _, level: _ } = hero;
    }








    /// A single pass for the subway. Tracks the number of uses.
    struct SubwayPass { uses: u8 }

    /// Get a new subway pass.
    public fun buy(/* pass a Coin? */): SubwayPass {
        /* ... */
        SubwayPass { uses: 10 }
    }

    /// Show it to the subway attendant; but don't allow to modify it.
    public fun show(pass: &SubwayPass): u8 {
        /* ... */
        pass.uses
    }

    /// Use the pass; the value inside can be modified.
    public fun single_use(pass: &mut SubwayPass) {
        /* ... */
        pass.uses = pass.uses - 1;
    }

    /// Top up the pass; the value inside can be modified.
    public fun topup(pass: &mut SubwayPass) {
        /* ... */
        pass.uses = pass.uses + 10;
    }

    /// "Move" the pass, lose the ownership.
    public fun recycle(pass: SubwayPass) {
        let SubwayPass { uses: _ } = pass;
    }















    /// `drop` ability allows the value to be discarded.
    struct Droppable has drop {
        some_info: vector<u8>
    }

    fun ignore_me(_: Droppable) {
        // ... no action required ...
    }










    /// `copy` ability allows the value to be copied
    struct Copyable has copy {
        level: u8
    }

    /// dereference operator performs a `copy` operation
    fun copy_me(copyable: &Copyable): Copyable {
        *copyable
    }










    /// any combination of abilities can be used
    struct PrimitiveValue has copy, drop {}

    fun primitive_set() {
        let value = PrimitiveValue {}; // ignored
        let _another = *&value; // copied

        // both values get discarded, never returned nor stored
    }






    /// can be called anywhere
    public fun visible() {}

    /// can't be called from another function
    entry fun protected_call() {}

    /// internal to module
    fun private() {}

    /// implemented in Rust, proxied by the VM
    native fun native_impl();

    /// public native function
    public native fun unsafe_bytes();

    #[test_only]
    /// only visible in tests
    public fun test_only() {}

}
