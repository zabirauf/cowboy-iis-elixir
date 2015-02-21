defmodule CowboyIIS do
  def start(_type, _args) do
    dispatch = :cowboy_router.compile([
        { :_, [
          {"/", :cowboy_static, {:priv_file, :cowboy_iis, "index.html"}},
          #{"/static/[...]", :cowboy_static, {:priv_dir, :cowboy_iis, "static_files"}}
          ]
        }
      ])

    {:ok, _ } = :cowboy.start_http(:http,
                                    100,
                                    [{:port, get_port()}],
                                    [{:env, [{:dispatch, dispatch}]}]
                                  )
  end

  def get_port() do
    # The String.strip is to remove any excesive space which IIS adds, not sure why
    System.get_env("PORT") |> String.strip |> String.to_integer
  end
end
