// store.sol -- authed nullable key-value store

// Copyright 2016-2017  Nexus Development, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// A copy of the License may be obtained at the following URL:
//
//    https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

pragma solidity ^0.4.9;

import 'ds-auth/auth.sol';

contract DSStoreEvents {
    event LogStoreChange( bytes32 indexed key, bytes32 indexed value, bool indexed is_set );
}

contract DSIStore is DSStoreEvents {
    function set(bytes32 key, bytes32 value);
    function unset(bytes32 key);
    function has(bytes32 key) constant returns (bool);
    function get( bytes32 key ) constant returns (bytes32 value);
    function tryGet( bytes32 key ) constant returns (bytes32 value, bool ok );
}

contract DSStore is DSIStore
                  , DSAuth
{
    struct NullableValue {
        bytes32 _value;
        bool    _set;
    }
    mapping( bytes32 => NullableValue ) _storage;

    function set(bytes32 key, bytes32 value )
             auth
    {
        _storage[key] = NullableValue(value, true);
        LogStoreChange( key, value, true );
    }
    function unset(bytes32 key)
             auth
    {
        _storage[key] = NullableValue(0x0, false);
        LogStoreChange( key, 0x0, false );
    }

    function has(bytes32 key)
             constant
             returns (bool)
    {
        return _storage[key]._set;
    }

    // Throws.
    function get( bytes32 key )
             constant
             returns (bytes32 value)
    {
        var (val, ok) = tryGet(key);
        if( !ok ) throw;
        return val;
    }

    function tryGet( bytes32 key ) constant returns (bytes32 value, bool ok ) {
        var nvalue = _storage[key];
        if( nvalue._set ) {
            return (nvalue._value, true);
        } else {
            return (0x0, false);
        }
    }

}
