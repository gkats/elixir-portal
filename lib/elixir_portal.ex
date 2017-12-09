defmodule ElixirPortal do
  defstruct [:left, :right]

  @doc """
  Starts transfering `data` from `left` to `right`.
  """
  def transfer(left, right, data) do
    for item <- data do
      ElixirPortal.Door.push(left, item)
    end

    %ElixirPortal{left: left, right: right}
  end

  @doc """
  Pushes data to the right in the given `portal`
  """
  def push_right(portal) do
    case ElixirPortal.Door.pop(portal.left) do
      :error -> :ok
      {:ok, h} -> ElixirPortal.Door.push(portal.right, h)
    end

    portal
  end

  @doc """
  Pushes data to the left in the given `portal`
  """
  def push_left(portal) do
    case ElixirPortal.Door.pop(portal.right) do
      :error -> :ok
      {:ok, h} -> ElixirPortal.Door.push(portal.left, h)
    end

    portal
  end

  @doc """
  Shoots a new door with the given `color`
  """
  def shoot(color) do
    Supervisor.start_child(ElixirPortal.Supervisor, [color])
  end
end

defimpl Inspect, for: ElixirPortal do
  def inspect(%ElixirPortal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data = inspect(Enum.reverse(ElixirPortal.Door.get(left)))
    right_data = inspect(ElixirPortal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.rjust(left_door, max)} <=> #{right_door}
      #{String.rjust(left_data, max)} <=> #{right_data}
    >
    """
  end
end