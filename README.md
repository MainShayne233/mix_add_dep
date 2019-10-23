# MixAddDep

A utility for programtically adding Elixir dependencies to a `mix.exs` file.

**Note**: Currently, this will remove all comments in the `mix.exs` file.

## Usage

You can use this in two ways: either via an executable, or in an Elixir app.

Either way, you pass in the dependencies as the string represenation of what you'd add to a `mix.exs` file. Valid examples include:
- `"{:decimal, \"~> 1.8\"}"`
- `"{:decimal, github: \"ericmj/decimal\"}"`
- `"{:decimal, path: \"../../some/path\"}"`
- etc


### Use as executable (escript)

Build and install:

```sh
# clone and enter repo
git clone https://github.com/MainShayne233/mix_add_dep.git
cd mix_add_dep

# build the executable
mix escript.build

# add the executable to your path (google "add executable to path" if not sure)
```

Now just move into an Elixir project and run it:

```sh
# can pass as many deps as desired
mix_add_dep '{:decimal, "~> 1.8"}' '{:jason, "~> 1.1"}'
```

### Use as dependency (in an Elixir app)

Add to deps:

```elixir
# mix.exs
def deps do
  [
    {:mix_add_dep, github: "MainShayne233/mix_add_dep"}
  ]
end
```

Get and install:

```sh
mix deps.get
```

Then call from within your app:

```elixir
iex> MixAddDep(["{:decimal, \"~> 1.8\"}", "{:jason, \"~> 1.1\"}"])
:ok
```
