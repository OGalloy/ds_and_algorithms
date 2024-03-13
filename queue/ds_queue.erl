-module(ds_queue).
-export([init/0, init/1, loop/1, insert/2, remove/1, peek/1, check/1]).


init() -> 
    spawn(?MODULE, loop, [[]]).

init(List) ->
    spawn(?MODULE, loop, [List]).

loop(List) ->
    receive
        {From, check} ->
            From ! {self(), List},
            loop(List);
        {From, insert, Value} ->
            From ! {self(), ok},
            loop([Value | List]);
        {From, remove} ->
            From ! {self(), ok},
            loop(lists:droplast(List));
        {From, peek} ->
            From ! {self(), lists:last(List)},
            loop(List)
    end.

check(Pid) ->
    Pid ! {self(), check},
    receive
        {From, List} -> {From, List}
    end.

insert(Pid, Value) ->
    Pid ! {self(), insert, Value},
    receive
        {From, ok} -> {From, ok}
    end.

remove(Pid) ->
    Pid ! {self(), remove},
    receive
        {From, ok} -> {From, ok}
    end.

peek(Pid) ->
    Pid ! {self(), peek},
    receive
        {From, Value} -> {From, Value}
    end.