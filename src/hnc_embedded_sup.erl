%% Copyright (c) 2020, Jan Uhlig <j.uhlig@mailingwork.de>
%% Copyright (c) 2020, Maria Scott <maria-12648430@gmx.net>
%%
%% Permission to use, copy, modify, and/or distribute this software for any
%% purpose with or without fee is hereby granted, provided that the above
%% copyright notice and this permission notice appear in all copies.
%%
%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
%% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
%% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-module(hnc_embedded_sup).

-behavior(supervisor).

-export([start_link/4]).
-export([init/1]).

-spec start_link(hnc:pool(), hnc:opts(), module(), term()) -> {ok, pid()}.
start_link(Name, Opts, Mod, Args) ->
        supervisor:start_link(?MODULE, {Name, Opts, Mod, Args}).

init({Name, Opts, Mod, Args}) ->
	{
		ok,
		{
			#{
				strategy => rest_for_one
			},
			[
				#{
					id => hnc_workercntl_sup_proxy,
					start => {hnc_workercntl_sup_proxy, start_link, []},
					shutdown => brutal_kill
				},
				#{
					id => {hnc_pool, Name},
					start => {hnc_pool_sup, start_link, [Name, Opts, Mod, Args]},
					type => supervisor
				}
			]
		}
	}.
