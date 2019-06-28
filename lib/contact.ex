defmodule Contact do
  # Takes an Email and Phone -> "blah@gmail.com: (541) 420-1760"
  @spec format(String.t(), String.t()) :: String.t()
  def format(str, str), do: "#{str}: #{str}"

  def format_args(email, phone), do: "#{email}: #{phone}"

  @spec format_types(Email.t(), Phone.t()) :: String.t()
  def format_types(email, phone), do: "#{Email.to_str(email)}: #{Phone.to_str(phone)}"
end

defmodule Messin do
  def stuff(str, str), do: Contact.format_types(Email.new!("asdf"), Phone.new!("asdf"))
end

defmodule Phone do
  @opaque t :: %__MODULE__{_: String.t()}
  @enforce_keys [:_]
  defstruct @enforce_keys

  @spec new!(str :: String.t()) :: t | no_return
  def new!(str) do
    if str == "blah" do
      %__MODULE__{_: str}
    else
      raise(ArgumentError, "bad phone number")
    end
  end

  @spec new(str :: String.t()) :: {:ok, t} | {:error, String.t()}
  def new(str) do
    if str == "blah" do
      {:ok, %__MODULE__{_: str}}
    else
      {:error, "bad phone number"}
    end
  end

  @spec to_str(t) :: String.t()
  def to_str(%__MODULE__{_: str}), do: str
end

defmodule Email do
  use TypedStruct

  typedstruct opaque: true do
    field :_, String.t(), enforce: true
  end

  @spec new!(str :: String.t()) :: t | no_return
  def new!(str) do
    if str == "blah" do
      %__MODULE__{_: str}
    else
      raise(ArgumentError, "bad email")
    end
  end

  @spec new(str :: String.t()) :: {:ok, t} | {:error, String.t()}
  def new(str) do
    if str == "blah" do
      {:ok, %__MODULE__{_: str}}
    else
      {:error, "bad phone number"}
    end
  end

  @spec to_str(t) :: String.t()
  def to_str(%__MODULE__{_: str}), do: str
end
