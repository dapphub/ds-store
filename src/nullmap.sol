/*
   Copyright 2016 Nexus Development, LLC

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

pragma solidity ^0.4.4;

import 'ds-auth/auth.sol';


contract DSNullMapEvents {
    event SetNullable( bytes32 indexed key, bytes32 indexed value, bool indexed is_set );
}

contract DSNullMap is DSAuth, DSNullMapEvents {
    struct NullableValue {
        bytes32 _value;
        bool    _set;
    }
    mapping( bytes32 => NullableValue ) _storage;

    function set(bytes32 key, bytes32 value )
             auth()
    {
        _storage[key] = NullableValue(value, true);
        SetNullable( key, value, true );
    }
    function unset(bytes32 key)
             auth()
    {
        _storage[key] = NullableValue(0x0, false);
        SetNullable( key, 0x0, false );
    }

    // Throws.
    function get( bytes32 key )
             constant
             returns (bytes32 value)
    {
        var nvalue = _storage[key];
        if( nvalue._set ) {
            return nvalue._value;
        } else {
            throw;
        }
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


