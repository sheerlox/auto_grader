defmodule AutoGrader.TestUnit do
  def run(_task_id) do
    sleep_time = :rand.uniform(5) * 1000
    Process.sleep(sleep_time)

    fail? = sleep_time >= 4000
    error? = :rand.uniform(10) >= 8

    cond do
      fail? and error? -> raise("An error occured in the test unit")
      fail? -> :fail
      true -> :pass
    end
  end
end
