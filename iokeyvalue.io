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

Echo := Object clone
Echo handleSocketFromServer := method(aSocket, aServer,
    write("[Got echo connection from ", aSocket host, "]\n")
    while(aSocket isOpen,
#           if(aSocket read, aSocket write(aSocket readBuffer asString))
        if (aSocket read,
            command := aSocket readBuffer asString split)

            if (command size == 1,
                aSocket write("Command too short: ")
                aSocket write(command at(0))
                aSocket write("\n"))
   
            # Get the actual command
            cmd := command at(0) asLowercase

            if (cmd == "set",
                aSocket write("SET "),
                aSocket write("Unknown command ")
                aSocket write(cmd)
                aSocket write("\n"))

            aSocket readBuffer empty)
            write("[Closed ", aSocket host, "]\n"))

port := System args at(1)

if (port isNil,
    "\nUsage: iokeyvalue PORT\n" print System exit)


write("\n [iokeyvalue] Starting server on port ",  port, "\n")
server := Server clone setPort(port asNumber)
server handleSocket := method(aSocket,
  Echo clone @handleSocketFromServer(aSocket, self)
  )
server start
