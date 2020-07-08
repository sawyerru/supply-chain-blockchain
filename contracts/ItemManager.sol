// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import './Item.sol';
import './Ownable.sol';

contract ItemManager is Ownable{

    enum Status { Created, Paid, Delivered } // Enum
    struct S_Item {
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.Status _status;
    }

    mapping(uint => S_Item) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);


    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner{
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._status = Status.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._status), address(item));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable {
        require(items[_itemIndex]._itemPrice == msg.value, 'Only Full Payments Accepted');
        require(items[_itemIndex]._status == Status.Created, 'Item further along in the Supply Chain');
        items[_itemIndex]._status = Status.Paid;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._status), address(items[_itemIndex]._item));

    }

    function triggerDelivery(uint _itemIndex) public onlyOwner {
        require(items[_itemIndex]._status == Status.Paid, 'Item further along in the Supply Chain');
        items[_itemIndex]._status = Status.Delivered;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._status), address(items[_itemIndex]._item));



    }
}