/*
 * Fake mkisofs to use wrapper script
 * Copyright (c) 2005 Gianluigi Tiesi <sherpya@netfarm.it>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

int RunWait(char *cmdline)
{
    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    DWORD exitcode = -1;
    TCHAR szCmdLine[MAX_PATH];

    ExpandEnvironmentStrings(cmdline, szCmdLine, MAX_PATH);

    ZeroMemory(&pi, sizeof(PROCESS_INFORMATION));
    ZeroMemory(&si, sizeof(STARTUPINFO));
    si.cb = sizeof(STARTUPINFO); 

    if(!CreateProcess(NULL, // No module name (use command line).
       szCmdLine,           // Command line.
       NULL,                // Process handle not inheritable.
       NULL,                // Thread handle not inheritable.
       TRUE,                // Set handle inheritance to TRUE.
       0,                   // No creation flags.
       NULL,                // Use parent's environment block.
       NULL,                // Use parent's starting directory.
       &si,                 // Pointer to STARTUPINFO structure.
       &pi ))               // Pointer to PROCESS_INFORMATION structure.
    return exitcode;

    WaitForSingleObject(pi.hProcess, INFINITE);
    GetExitCodeProcess(pi.hProcess, &exitcode);

    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    return (int) exitcode;
}

int main(int argc, char *argv[])
{
    char cmd[MAX_PATH];
    char wrapper[MAX_PATH];
    unsigned int i;
   
    if (argc < 3) return -1;
    
    if (!GetFullPathName(argv[0], MAX_PATH, wrapper, NULL))
        return -1;

    for (i = strlen(wrapper); ((i > 0) && (wrapper[i] != '\\')) ; i--);
    wrapper[i] = 0;
    SetCurrentDirectory(wrapper);
    sprintf(cmd, "cmd.exe /c \"\"%s\\wrapper.cmd\" \"%s\" \"%s\"\"", wrapper, argv[argc-2], argv[argc-1]);

    /* Set no buffer for standard output */
    setbuf(stdout, NULL);
    printf("Wrapper: %s\n", cmd);
    return RunWait(cmd);
}
