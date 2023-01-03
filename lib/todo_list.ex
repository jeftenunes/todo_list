defmodule TodoList do
  defstruct auto_id: 0, entries: %{}

  def new, do: %__MODULE__{}

  def add_entry(todo_list, title, description \\ nil, date \\ Date.utc_today()) do
    entry = %{
      title: title,
      description: description,
      date: date
    }

    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)
    %__MODULE__{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def entries(todo_list), do: todo_list.entries

  def entries(todo_list, date_filter) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == Date.from_iso8601!(date_filter) end)
    |> Enum.map(fn {_, entry} -> {entry.title, entry.description} end)
  end

  def update_at(id, todo_list, entry = %{title: _, description: _, date: _}) do
    Map.put(todo_list, id, entry)
  end
end
