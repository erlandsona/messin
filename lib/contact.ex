# Norm
# https://github.com/keathley/norm
# We get most of the benefits of Norm without a custom DSL.
# What we don't get from these (yet!) is generators...
#
# Opaque Types also encourage a code level normalization similar to what you do
# at the database level.

defmodule Phone do
  @type t :: %__MODULE__{_: String.t()}
  @enforce_keys [:_]
  defstruct @enforce_keys

 @spec new!(str :: String.t()) :: t | no_return
 def new!(str) do
   if str == "555-555-5555" do
     %__MODULE__{_: str}
   else
     raise(ArgumentError, "bad phone number")
   end
 end

 @spec new(str :: String.t()) :: {:ok, t()} | {:error, String.t()}
 def new(str) do
   if str == "555-555-5555" do
     {:ok, %__MODULE__{_: str}}
   else
     {:error, "bad phone number"}
   end
 end

  @spec _(t) :: String.t()
  def _(%__MODULE__{_: str}), do: str
end

defmodule Email do
  use TypedEctoSchema

  @primary_key {:_, :string, enforce: true, null: false}
  typed_embedded_schema do
    # field(:_, :string, enforce: true, null: false)
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

  @spec _(t) :: String.t()
  def _(%__MODULE__{_: str}), do: str

  # NOTE: Not sure I prefer this to defining a custom formatter
  # because this is akin to the "Logging / Debugging with Haskell's Show instance"
  # which is an anti-pattern due to lack of serializability / a common interface

  # defimpl String.Chars do
  #   @spec to_string(Email.t()) :: String.t()
  #   def to_string(%Email{_: str}), do: str
  # end
end

#defmodule St do
#  use TypedEctoSchema

#  @primary_key false
#  typed_embedded_schema opaque: true do
#    field(:_, :string, enforce: true, null: false) ::
#      :oregon | :washington | :colorado | :tennessee | :new_york
#  end

#  @spec to_s(t()) :: String.t()
#  def to_s(%St{_: st}), do: Atom.to_string(st)

#  @spec new!(atom()) :: t() | no_return()
#  def new!(st) do
#    if st in [:oregon, :washington, :colorado, :tennessee, :new_york] do
#      %__MODULE__{_: st}
#    else
#      raise(ArgumentError, "Unrecognized state")
#    end
#  end

#end

#defmodule Address do
#  use TypedEctoSchema

#  @primary_key false
#  typed_embedded_schema do
#    field(:street, :string, enforce: true, null: false)
#    field(:unit, :string, enforce: true)
#    field(:city, :string, enforce: true, null: false)
#    field(:state, :string, enforce: true, null: false) :: St.t()
#  end

#  @spec new!(street :: String.t(), city :: String.t(), state :: St.t(), unit :: String.t() | nil) ::
#          t | no_return
#  def new!(street, city, state, unit) do
#    %__MODULE__{street: street, unit: unit, city: city, state: state}
#  end

#  @spec format(t) :: String.t()
#  def format(%__MODULE__{street: street, unit: unit, city: city, state: st}) do
#    "#{street} #{unit || ""}
#    #{city}, #{St.to_s(st)}"
#  end
#end

#defmodule Contact do
#  # Takes an Email and Phone -> "blah@gmail.com: (541) 420-1760"
#  @spec format(String.t(), String.t(), String.t()) :: String.t()
#  def format(str, stb, stc), do: "#{str}: #{stb} #{stc}"

#  def format_args(email, phone, address), do: "#{email}: #{phone} #{address}"

#  @spec format_types(Email.t(), Phone.t(), Address.t()) :: String.t()
#  def format_types(email, phone, address),
#    do: "#{Email._(email)}: #{Phone._(phone)}\n#{Address.format(address)}"
#end

#defmodule Messin do
#  @spec stuff() :: String.t() | no_return
#  def stuff() do
#    Contact.format_types(
#      Email.new!("blah"),
#      Phone.new!("blah"),
#      Address.new!("555 5th St", "Nash", St.new!(:tennessee), "C")
#    )
#  end
#end

#defmodule Controller do
#  @spec handle(Email.t() | Phone.t() | Address.t()) :: String.t()
#  def handle(%Address{} = e), do: Address.format(e)
#  def handle(%Email{} = e), do: Email._(e)
#  def handle(%Phone{} = e), do: Phone._(e)
#  # Missing Phone branch makes this function non-exhaustive.
#  # This should be a type failure but with "Success" typing
#  # this function passes.
#  # Our types are lying to us about the safety of our program.
#  #
#  # %Phone{} = e ->
#  #   Phone._(e)
#end

#defmodule Test do
#  def blah(), do: Controller.handle(Email.new!("Stuff"))
#end
defmodule FunThing do
  def my_function(some_arg, other) do
    if String.contains?(some_arg, "@") do
      "#{some_arg}, #{other}"
    else
      "#{other}, #{some_arg}"
    end
  end

  def format(email, phone), do: "#{email}, #{phone}"

  @spec format_with_types(Phone.t() | Email.t()) :: String.t()
  def format_with_types(credential) do
    case credential do
      %Email{} = cred ->
        "#{cred}"

      %Phone{} = cred ->
        "#{Phone._(cred)}"
    end
  end
end

defmodule Controller do
  def index do
    FunThing.format_with_types(%Email{_: "Stuff"})
  end
end
