#!/usr/bin/env io

# Copyright (c) 2013, Alexander Kluth
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

Connection := Object clone
Connection store := KeyValueStore clone
Connection callback := method(aSocket, aServer,

    write("[Got echo connection from ", aSocket host, "]\n")
    while(aSocket isOpen,
        if (aSocket read,
            inputBuffer := aSocket readBuffer asString split)

            if (inputBuffer isNil, aSocket write("Empty.") return())

            if (inputBuffer size == 1,
                aSocket write("Command too short: ")
                aSocket write(inputBuffer at(0))
                aSocket write("\n"))
   
            # Get the actual command
            cmd := inputBuffer at(0) asLowercase
            commands := Commands getSlot(cmd)

            if (Commands getSlot(cmd) isNil,
                aSocket write("UNKNOWN")
                return(255))

            if (cmd == "set",
                key := inputBuffer at(1)
                value := inputBuffer at(2)
                store set(key, value)

                aSocket write("SET ")
                aSocket write(key)
                aSocket write(" VALUE ")
                aSocket write(value)
                aSocket write("\n"))

            if (cmd == "get",
                aSocket write(store get(inputBuffer at(1)))
                aSocket write("\n"))

            aSocket readBuffer empty)
            write(" closed", aSocket host, "\n"))
