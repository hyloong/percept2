
-module(server). 
-compile(export_all).
start() ->
    erlang:set_cookie(node(),inviso),
    application:start(runtime_tools),
    Pid = spawn(?MODULE,loop,[[]]),
    register(server,Pid).
stop() -> server ! stop.
loop(Data) ->
    receive
        {put,From,Ting} -> From ! whatis(Ting),
                           loop(Data ++ [Ting]);
        {get,From}      -> From ! {ok,length(Data)},
                           loop(Data);
        stop            -> stopped;
        clear           -> loop([])
    end.
whatis(List) when hd(List) =< 96 -> nok;
whatis(List) when hd(List) == 99 -> nok; %% Intentional bug for demonstration,
                                         %% all others are accidental
whatis(List) when hd(List) == 100 -> ok;
whatis(List) when hd(List) == 101 -> ok;
whatis(List) when hd(List) >= 123 -> nok;
whatis(List) when is_integer(hd(List)) -> ok.
