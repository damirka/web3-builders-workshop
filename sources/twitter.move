// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

/// A simple Twitter-like module that allows users to create accounts and post
/// messages. No messages can be deleted, no censorship is possible, immutability
/// is guaranteed.
module twitter::twitter {
    use std::option::Option;
    use std::string::String;
    use sui::object::{Self, ID, UID};
    use sui::tx_context::{sender, TxContext};
    use sui::transfer;
    use sui::event;
    use sui::dynamic_field as df;

    // owner: address
    // data: ****
    // version: number
    // digest: hash
    // id: UID

    struct Account has key {
        id: UID,
        name: String
    }

    struct Tweet has key {
        id: UID,
        account: ID,
        message: String,
        like_counter: u32,
    }

    struct Reply has key, store {
        id: UID,
        account: ID,
        message: String,
    }

    struct Retweet has key {
        id: UID,
        tweet: ID,
        account: ID,
        message: Option<String>
    }

    struct TweetCreated has copy, drop {
        id: ID,
        from: ID
    }

    public fun create_account(name: String, ctx: &mut TxContext) {
        let account = Account {
            id: object::new(ctx),
            name,
        };

        transfer::transfer(account, sender(ctx));
    }

    public fun tweet(account: &Account, message: String, ctx: &mut TxContext) {
        let tweet = Tweet {
            id: object::new(ctx),
            account: object::id(account),
            message,
            like_counter: 0
        };

        event::emit(TweetCreated {
            id: object::id(&tweet),
            from: object::id(account)
        });

        transfer::share_object(tweet);
    }

    public fun retweet(
        account: &Account,
        tweet: &Tweet,
        message: Option<String>,
        ctx: &mut TxContext
    ) {
        let retweet = Retweet {
            id: object::new(ctx),
            tweet: object::id(tweet),
            account: object::id(account),
            message,
        };

        transfer::share_object(retweet);
    }

    public fun reply(
        account: &Account,
        tweet: &mut Tweet,
        message: String,
        ctx: &mut TxContext
    ) {
        let reply = Reply {
            id: object::new(ctx),
            account: object::id(account),
            message,
        };

        let id: ID = object::id(&reply);

        df::add(&mut tweet.id, id, reply);
    }

    public fun like(tweet: &mut Tweet) {
        tweet.like_counter = tweet.like_counter + 1;
    }
}
