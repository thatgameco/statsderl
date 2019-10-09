-module(statsderl_udp).
-include("statsderl.hrl").

-compile(inline).
-compile({inline_size, 512}).
-compile({nowarn_unused_function, [{uint32, 1}]}).

-ignore_xref([
    {?MODULE, uint32, 1}
]).

-export([
    header/2
]).

-define(INET_AF_INET, 1).
-define(INT16(X), [((X) bsr 8) band 16#ff, (X) band 16#ff]).

%% public
-spec header(inet:ip_address(), inet:port_number()) ->
    iodata().

-ifdef(UDP_HEADER_1).

header(IP, Port) ->
    [?INT16(Port), ip4_to_bytes(IP)].

-else.
-ifdef(UDP_HEADER_2).

header(IP, Port) ->
    [?INET_AF_INET, ?INT16(Port), ip4_to_bytes(IP)].

-else.

header(IP, Port) ->
    [?INET_AF_INET, ?INT16(Port), ip4_to_bytes(IP), uint32(0)].

-endif.
-endif.

%% private
ip4_to_bytes({A, B, C, D}) ->
    [A band 16#ff, B band 16#ff, C band 16#ff, D band 16#ff].

uint32(X) ->
    [((X) bsr 24) band 16#ff, ((X) bsr 16) band 16#ff,
     ((X) bsr 8) band 16#ff, (X) band 16#ff].
