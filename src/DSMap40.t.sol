/// DSMap40.t.sol -- tests for DSMap40

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

import "dapple/test.sol";

import "DSMap40.sol";

contract DSMap40Test is Test, DSMap40Events {
    DSMap40 map = new DSMap40();

    function testFail_get_1() {
        map.get(0);
    }

    function testFail_get_2() {
        map.get(0x1234);
    }

    function test_get() {
        expectEventsExact(map);
        assert_get(0x0000, false, 0x0000);
        assert_get(0x1234, false, 0x0000);
    }

    function test_set() {
        expectEventsExact(map);
        set(0x0000, 0x0000);
        assert_get(0x0000, true, 0x0000);
        assert_get(0x1234, false, 0x0000);
        set(0x1234, 0x5678);
        assert_get(0x0000, true, 0x0000);
        assert_get(0x1234, true, 0x5678);
    }

    function set(bytes32 key, bytes32 value) internal {
        LogSet(key, value, uint(-1));
        map.set(key, value);
    }

    function assert_get(bytes32 key, bool expectedHas, bytes32 expected) {
        bool ok = map.call.gas(10000)(bytes4(sha3("get(bytes32)")), key);

        if (expectedHas) {
            assertTrue(ok);
            assertTrue(map.has(key));
            assertEq32(map.get(key), expected);
        } else {
            assertFalse(ok);
            assertFalse(map.has(key));
        }
    }
}
