defmodule VltLabsWizard.FinanceTest do
  use VltLabsWizard.DataCase

  alias VltLabsWizard.Finance

  describe "man_day_purchase" do
    alias VltLabsWizard.Finance.ManDayPurchase

    @valid_attrs %{days_purchased: "120.5", purchased_on: ~D[2010-04-17], total_cost: "120.5"}
    @update_attrs %{days_purchased: "456.7", purchased_on: ~D[2011-05-18], total_cost: "456.7"}
    @invalid_attrs %{days_purchased: nil, purchased_on: nil, total_cost: nil}

    def man_day_purchase_fixture(attrs \\ %{}) do
      {:ok, man_day_purchase} =
        attrs
        |> Enum.into(%{project_id: insert(:project).id})
        |> Enum.into(@valid_attrs)
        |> Finance.create_man_day_purchase()

      man_day_purchase
    end

    test "list_man_day_purchase/0 returns all man_day_purchase" do
      man_day_purchase = man_day_purchase_fixture()
      assert Finance.list_man_day_purchase() == [man_day_purchase]
    end

    test "get_man_day_purchase!/1 returns the man_day_purchase with given id" do
      man_day_purchase = man_day_purchase_fixture()
      assert Finance.get_man_day_purchase!(man_day_purchase.id) == man_day_purchase
    end

    test "create_man_day_purchase/1 with valid data creates a man_day_purchase" do

      man_day_purchase = man_day_purchase_fixture()
      assert man_day_purchase.days_purchased == Decimal.new("120.5")
      assert man_day_purchase.purchased_on == ~D[2010-04-17]
      assert man_day_purchase.total_cost == Decimal.new("120.5")
    end

    test "create_man_day_purchase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_man_day_purchase(@invalid_attrs)
    end

    test "update_man_day_purchase/2 with valid data updates the man_day_purchase" do
      man_day_purchase = man_day_purchase_fixture()
      assert {:ok, man_day_purchase} = Finance.update_man_day_purchase(man_day_purchase, @update_attrs)
      assert %ManDayPurchase{} = man_day_purchase
      assert man_day_purchase.days_purchased == Decimal.new("456.7")
      assert man_day_purchase.purchased_on == ~D[2011-05-18]
      assert man_day_purchase.total_cost == Decimal.new("456.7")
    end

    test "update_man_day_purchase/2 with invalid data returns error changeset" do
      man_day_purchase = man_day_purchase_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_man_day_purchase(man_day_purchase, @invalid_attrs)
      assert man_day_purchase == Finance.get_man_day_purchase!(man_day_purchase.id)
    end

    test "delete_man_day_purchase/1 deletes the man_day_purchase" do
      man_day_purchase = man_day_purchase_fixture()
      assert {:ok, %ManDayPurchase{}} = Finance.delete_man_day_purchase(man_day_purchase)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_man_day_purchase!(man_day_purchase.id) end
    end

    test "change_man_day_purchase/1 returns a man_day_purchase changeset" do
      man_day_purchase = man_day_purchase_fixture()
      assert %Ecto.Changeset{} = Finance.change_man_day_purchase(man_day_purchase)
    end
  end
end
