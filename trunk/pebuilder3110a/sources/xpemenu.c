/*
 * Simple Menu to Start XPE and other tools
 * Copyright (c) 2005 Gianluigi Tiesi <sherpya@netfarm.it>
 * Based on code from syslinux
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

#ifndef NULL
#define NULL ((void *) 0)
#endif

#include "menu.h"
#include "biosio.h"
#include "string.h"
#include "syslinux.h"

//#define DEBUG

/*
    Clears keyboard buffer and then
    wait for stepsize*numsteps milliseconds for user to press any key
    checks for keypress every stepsize milliseconds.
    Returns: 1 if user pressed a key (not read from the buffer),
             0 if time elapsed
*/

int checkkeypress(int stepsize, int numsteps)
{
    int i;
    clearkbdbuf();
    for (i=0; i < numsteps; i++)
    {
        if (checkkbdbuf()) return 1;
        sleep(stepsize);
        if (!(i % 10)) csprint(".", 0x7);
    }
    return 0;
}

int menumain(char *cmdline)
{
    t_menuitem * curr;

    char mainmenu, rescue, mem;
    (void)cmdline; /* Not used */

    init_menusystem("Windows XPE Menu System - (c) 2005 Gianluigi Tiesi");
    set_window_size(1, 1, 23, 78); /* Leave one row/col border all around */

    mem = add_menu(" Memory Testing ");
    add_item("<M>emTest86", "Launch Memtest86", OPT_RUN, "m86", 0);
    add_item("Mem<T>est86+","Launch Memtest86+", OPT_RUN, "m86+", 0);
    add_item("E<x>it this menu","Go one level up", OPT_EXITMENU, "exit", 0);

    rescue = add_menu(" Rescue Options ");
    add_item("Power<M>ax","PowerMax Utility", OPT_RUN, "powermax", 0);
    add_item("<P>CI Utils","PCI Detection Utility", OPT_RUN, "pci", 0);
    add_item("E<x>it this menu","Go one level up", OPT_EXITMENU, "exit", 0);

    mainmenu = add_menu(" Main Menu");
    add_item("Windows <X>PE", "Start Windows XPE", OPT_RUN, "xpe", 0);
    add_item("<R>escue","Rescue options", OPT_SUBMENU, NULL, rescue);
    add_item("<M>emory Test","Perform extensive memory testing", OPT_SUBMENU, NULL, mem);
    /* add_item("Exit to prompt", "Exit the menu system", OPT_EXITMENU, "exit", 0); */

#ifndef DEBUG
    clearwindow(0, 0, 23, 80, 0, 32, 0);
    clearwindow(0, 0, 0, 0, 0, 0, 0);
    csprint("Press any key within 5 seconds to show menu", 0x7);
    if (!checkkeypress(100, 50)) /* Granularity of 100 milliseconds */
    {
        csprint("\r\n", 0x7);
        runcommand("hd");
        return 1;
    }
    else clearkbdbuf(); /* Just in case user pressed something important */
    csprint("\r\n", 0x7);
#endif

    curr = showmenus(mainmenu);
    if (curr)
    {
        if (curr->action == OPT_RUN)
        {
            if (syslinux) runcommand(curr->data);
            else csprint(curr->data, 0x7);
            return 1;
        }
        csprint("Error in programming!", 0x7);
    }
    return 0;
}
