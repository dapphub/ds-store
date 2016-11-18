/// DSMap9.sol -- 12-to-32-byte key-value store with expiration

// Copyright 2016  Nexus Development, LLC
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

pragma solidity ^0.4.4;

import "ds-auth/auth.sol";

contract DSMap9Events {
    event LogUpdate(
        bytes12 indexed  key,
        bytes32 indexed  value,
        uint             expiry
    );
}

contract DSMap9 is DSAuth, DSMap9Events {
    mapping (bytes12 => bytes32)      values;
    mapping (bytes12 => uint) public  expiry;

    function has(bytes12 key) constant returns (bool) {
        return now < expiry[key];
    }

    function get(bytes12 key) constant returns (bytes32) {
        if (has(key)) {
            return values[key];
        } else {
            throw;
        }
    }

    function set(bytes12 key, bytes32 newValue, uint newExpiry) auth {
        values[key] = newValue;
        expiry[key] = newExpiry;
        LogUpdate(key, newValue, newExpiry);
    }

    function set(bytes12 key, bytes32 newValue) auth {
        set(key, newValue, uint(-1));
    }

    function unset(bytes12 key) auth {
        set(key, 0, 0);
    }
}
