defmodule SetPartitions do
  @moduledoc """
  Inspired by M. Orlov, 2002, 'Efficient Generation of Set Partitions'
  """

  def for_raw(init, pred, op, state, block) do
    if pred.(init) do
      for_raw(op.(init), pred, op, block.(init, state), block)
    else
      state
    end
  end

  def for_n(:asc, from: n, to: m) do
    Stream.unfold(n, fn
      n when n <= m -> {n, n + 1}
      _ -> nil
    end)
  end

  def for_n(:desc, from: n, to: m) do
    Stream.unfold(n, fn
      n when n >= m -> {n, n - 1}
      _ -> nil
    end)
  end

  def initialize_first(n) do
    k = Tuple.duplicate(0, n)
    m = k
    {k, m}
  end

  def initialize_last(n) do
    k = Tuple.duplicate(0, n)
    m = k

    Enum.reduce(0..(n - 1), {k, m}, fn i, {k, m} ->
      {put_elem(k, i, i), put_elem(m, i, i)}
    end)
  end

  def next_partition({k, m}), do: next_partition(k, m)

  def next_partition(k, m) do
    n = tuple_size(k)

    Enum.reduce_while(for_n(:desc, from: n - 1, to: 1), :fail, fn i, :fail ->
      k0 = elem(k, 0)
      ki = elem(k, i)
      mi = elem(m, i)

      if ki <= elem(m, i - 1) do
        k = put_elem(k, i, ki + 1)
        m = put_elem(m, i, max(mi, elem(k, i)))
        mi = elem(m, i)

        km =
          Enum.reduce(for_n(:asc, from: i + 1, to: n - 1), {k, m}, fn j, {k, m} ->
            k = put_elem(k, j, k0)
            m = put_elem(m, j, mi)
            {k, m}
          end)

        {:halt, km}
      else
        {:cont, :fail}
      end
    end)
  end

  def partition_size(m), do: elem(m, tuple_size(m) - 1) - elem(m, 0) + 1

  def p_initialize_first(n, p) when p <= 0 or p > n do
    raise("p must be in 1..#{n}, received: #{p}")
  end

  def p_initialize_first(n, p) do
    k = Tuple.duplicate(0, n)
    m = k

    {k, m} =
      Enum.reduce(for_n(:asc, from: n - p + 1, to: n - 1), {k, m}, fn i, {k, m} ->
        {put_elem(k, i, i - (n - p)), put_elem(m, i, i - (n - p))}
      end)

    {k, m, p}
  end

  def p_initialize_last(n, p) do
    k = Tuple.duplicate(0, n)
    m = k

    {k, m} =
      Enum.reduce(for_n(:asc, from: 0, to: n - p), {k, m}, fn i, {k, m} ->
        {put_elem(k, i, i), put_elem(m, i, i)}
      end)

    {k, m} =
      Enum.reduce(for_n(:asc, from: n - p + 1, to: n - 1), {k, m}, fn i, {k, m} ->
        {put_elem(k, i, p - 1), put_elem(m, i, p - 1)}
      end)

    {k, m, p}
  end

  def p_next_partition({k, m, p}), do: p_next_partition(k, m, p)

  def p_next_partition(k, m, p) do
    n = tuple_size(k)

    Enum.reduce_while(for_n(:desc, from: n - 1, to: 1), :fail, fn i, :fail ->
      k0 = elem(k, 0)
      ki = elem(k, i)
      mi = elem(m, i)

      if ki < p - 1 and ki <= elem(m, i - 1) do
        k = put_elem(k, i, ki + 1)
        m = put_elem(m, i, max(mi, elem(k, i)))
        mi = elem(m, i)

        {k, m} =
          Enum.reduce(for_n(:asc, from: i + 1, to: n - (p - mi)), {k, m}, fn j, {k, m} ->
            k = put_elem(k, j, k0)
            m = put_elem(m, j, mi)
            {k, m}
          end)

        {k, m} =
          Enum.reduce(for_n(:asc, from: n - (p - mi) + 1, to: n - 1), {k, m}, fn j, {k, m} ->
            k = put_elem(k, j, p - (n - j))
            m = put_elem(m, j, p - (n - j))
            {k, m}
          end)

        {:halt, {k, m, p}}
      else
        {:cont, :fail}
      end
    end)
  end
end
