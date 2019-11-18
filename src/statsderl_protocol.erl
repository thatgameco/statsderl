-module(statsderl_protocol).
-include("statsderl.hrl").

-compile(inline).
-compile({inline_size, 512}).

-export([
    encode/1
]).

%% public
-spec encode(operation()) -> iodata().

encode({counter, Key, Value, SampleRate, Tags}) ->
    [Key, <<":">>, format_value(Value), <<"|c">>,
        format_sample_rate(SampleRate),
        format_tags(Tags)];
encode({gauge, Key, Value, Tags}) ->
    [Key, <<":">>, format_value(Value), <<"|g">>,
        format_tags(Tags)];
encode({gauge_decrement, Key, Value, Tags}) ->
    [Key, <<":-">>, format_value(Value), <<"|g">>,
        format_tags(Tags)];
encode({gauge_increment, Key, Value, Tags}) ->
    [Key, <<":+">>, format_value(Value), <<"|g">>, 
        format_tags(Tags)];
encode({timing, Key, Value, Tags}) ->
    [Key, <<":">>, format_value(Value), <<"|ms">>,
        format_tags(Tags)].

%% private
format_sample_rate(SampleRate) when SampleRate >= 1 ->
    <<>>;
format_sample_rate(SampleRate) ->
    [<<"|@">>, float_to_list(SampleRate, [compact, {decimals, 6}])].

format_value(Value) when is_integer(Value) ->
    integer_to_list(Value);
format_value(Value) when is_float(Value) ->
    float_to_list(Value, [{decimals, 2}]).

format_tags_impl([{Name, Value} | Tags], Result) ->
    Value2 = case Value of 
        Bin when is_binary(Bin) -> binary_to_list(Bin);
        Atom when is_atom(Atom) -> atom_to_list(Atom);
        Other -> Other
    end,
    format_tags_impl(Tags, [[Name, <<":">>, Value2] | Result]);
format_tags_impl([Name | Tags], Result) ->
    format_tags_impl(Tags, [Name | Result]);
format_tags_impl([], Result) ->
    lists:join(<<",">>, lists:reverse(Result)).
format_tags([]) ->
    <<>>;
format_tags(Tags) ->
    [<<"|#">>, format_tags_impl(Tags, [])].
