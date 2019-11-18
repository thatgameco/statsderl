-module(statsderl).
-include("statsderl.hrl").

-compile(inline).
-compile({inline_size, 512}).

%% public
-export([
    counter/3,
    decrement/3,
    gauge/3,
    gauge_decrement/3,
    gauge_increment/3,
    increment/3,
    timing/3,
    timing_fun/3,
    timing_now/3,
    timing_now_us/3,

    counter/4,
    decrement/4,
    gauge/4,
    gauge_decrement/4,
    gauge_increment/4,
    increment/4,
    timing/4,
    timing_fun/4,
    timing_now/4,
    timing_now_us/4
]).

%% public
-spec counter(key(), value(), sample_rate(), tags()) ->
    ok.

counter(Key, Value, Rate) -> counter(Key, Value, Rate, []).
counter(Key, Value, Rate, Tags) ->
    statsderl_sample:rate(Rate, {counter, Key, Value, Rate, Tags}).

-spec decrement(key(), value(), sample_rate(), tags()) ->
    ok.

decrement(Key, Value, Rate) -> decrement(Key, Value, Rate, []).
decrement(Key, Value, Rate, Tags) when Value >= 0 ->
    statsderl_sample:rate(Rate, {counter, Key, -Value, Rate, Tags}).

-spec gauge(key(), value(), sample_rate(), tags()) ->
    ok.

gauge(Key, Value, Rate) -> gauge(Key, Value, Rate, []).
gauge(Key, Value, Rate, Tags) when Value >= 0 ->
    statsderl_sample:rate(Rate, {gauge, Key, Value, Tags}).

-spec gauge_decrement(key(), value(), sample_rate(), tags()) ->
    ok.

gauge_decrement(Key, Value, Rate) -> gauge_decrement(Key, Value, Rate, []).
gauge_decrement(Key, Value, Rate, Tags) when Value >= 0 ->
    statsderl_sample:rate(Rate, {gauge_decrement, Key, Value, Tags}).

-spec gauge_increment(key(), value(), sample_rate(), tags()) ->
    ok.

gauge_increment(Key, Value, Rate) -> gauge_increment(Key, Value, Rate, []).
gauge_increment(Key, Value, Rate, Tags) when Value >= 0 ->
    statsderl_sample:rate(Rate, {gauge_increment, Key, Value, Tags}).

-spec increment(key(), value(), sample_rate(), tags()) ->
    ok.

increment(Key, Value, Rate) -> increment(Key, Value, Rate, []).
increment(Key, Value, Rate, Tags) when Value >= 0 ->
    statsderl_sample:rate(Rate, {counter, Key, Value, Rate, Tags}).

-spec timing(key(), value(), sample_rate(), tags()) ->
    ok.

timing(Key, Value, Rate) -> timing(Key, Value, Rate, []).
timing(Key, Value, Rate, Tags) ->
    statsderl_sample:rate(Rate, {timing, Key, Value, Tags}).

-spec timing_fun(key(), fun(), sample_rate(), tags()) ->
    ok.

timing_fun(Key, Fun, Rate) -> timing_fun(Key, Fun, Rate, []).
timing_fun(Key, Fun, Rate, Tags) ->
    Timestamp = statsderl_utils:timestamp(),
    Result = Fun(),
    timing_now(Key, Timestamp, Rate, Tags),
    Result.

-spec timing_now(key(), erlang:timestamp(), sample_rate(), tags()) ->
    ok.

timing_now(Key, Timestamp, Rate) -> timing_now(Key, Timestamp, Rate, []).
timing_now(Key, Timestamp, Rate, Tags) ->
    statsderl_sample:rate(Rate, {timing_now, Key, Timestamp, Tags}).

-spec timing_now_us(key(), erlang:timestamp(), sample_rate(), tags()) ->
    ok.

timing_now_us(Key, Timestamp, Rate) -> timing_now_us(Key, Timestamp, Rate, []).
timing_now_us(Key, Timestamp, Rate, Tags) ->
    statsderl_sample:rate(Rate, {timing_now_us, Key, Timestamp, Tags}).
