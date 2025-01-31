/*
 * BSD 2-Clause License
 *
 * Copyright (C) 2014-2016, Lazaros Koromilas <lostd@2f30.org>
 * Copyright (C) 2014-2016, Dimitris Papastamos <sin@2f30.org>
 * Copyright (C) 2016-2023, Arun Prakash Jana <engineerarun@gmail.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#pragma once

#include <curses.h>
#include <wchar.h>

#define CONTROL(c) ((c) & 0x1f)
#define ALT(c) ((c) | 0x80)

#ifndef ESC
#define ESC (27)
#endif

#ifndef DEL
#define DEL (127)
#endif

/* Supported actions */
enum action {
	SEL_BACK = 1,
	SEL_OPEN,
	SEL_NAV_IN,
	SEL_NEXT,
	SEL_PREV,
	SEL_PGDN,
	SEL_PGUP,
	SEL_CTRL_D,
	SEL_CTRL_U,
	SEL_HOME,
	SEL_END,
	SEL_FIRST,
	SEL_JUMP,
	SEL_CDHOME,
	SEL_CDBEGIN,
	SEL_CDLAST,
	SEL_CDROOT,
	SEL_BMOPEN,
	SEL_REMOTE,
	SEL_CYCLE,
	SEL_CYCLER,
	SEL_CTX1,
	SEL_CTX2,
	SEL_CTX3,
	SEL_CTX4,
#ifdef CTX8
	SEL_CTX5,
	SEL_CTX6,
	SEL_CTX7,
	SEL_CTX8,
#endif
	SEL_MARK,
	SEL_BMARK,
	SEL_FLTR,
	SEL_MFLTR,
	SEL_HIDDEN,
	SEL_DETAIL,
	SEL_STATS,
	SEL_CHMODX,
	SEL_ARCHIVE,
	SEL_SORT,
	SEL_REDRAW,
	SEL_SEL,
	SEL_SELMUL,
	SEL_SELALL,
	SEL_SELINV,
	SEL_SELEDIT,
	SEL_CP,
	SEL_MV,
	SEL_CPMVAS,
	SEL_RM,
	SEL_OPENWITH,
	SEL_NEW,
	SEL_RENAME,
	SEL_RENAMEMUL,
	SEL_UMOUNT,
	SEL_HELP,
	SEL_AUTONEXT,
	SEL_EDIT,
	SEL_PLUGIN,
	SEL_SELSIZE,
	SEL_SHELL,
	SEL_LAUNCH,
	SEL_PROMPT,
	SEL_LOCK,
	SEL_SESSIONS,
	SEL_EXPORT,
	SEL_TIMETYPE,
	SEL_QUITCTX,
	SEL_QUITCD,
	SEL_QUIT,
	SEL_QUITERR,
#ifndef NOMOUSE
	SEL_CLICK,
#endif
};

/* Associate a pressed key to an action */
struct key {
	wint_t sym;      /* Key pressed */
	enum action act; /* Action */
};

static struct key bindings[] = {
	{ '?',            SEL_HELP },     /* Help */
	{ 'q',            SEL_QUITCTX },  /* Quit a context */
	{ ';',            SEL_PLUGIN },   /* Run a plugin */
	{ CONTROL('Q'),   SEL_QUIT },     /* Quit */
	{ CONTROL('K'),   SEL_QUITCD },   /* Change dir on quit */ // WHAT
	
	{ 'b',            SEL_BMOPEN },   /* Leader key */ // Opens bookmarks
	{ '~',            SEL_CDHOME },   /* HOME */
	{ '@',            SEL_CDBEGIN },  /* Initial directory */
	{ '-',            SEL_CDLAST },   /* Last visited dir */
	{ '`',            SEL_CDROOT },   /* Go to / */
	
	{ KEY_LEFT,       SEL_BACK },     /* Back */
	{ KEY_RIGHT,      SEL_NAV_IN },   /* Pure navigate inside */
	{ KEY_DOWN,       SEL_NEXT },     /* Next */
	{ KEY_UP,         SEL_PREV },     /* Previous */
	{ KEY_NPAGE,      SEL_CTRL_D },   /* ½ Page down */
	{ KEY_PPAGE,      SEL_CTRL_U },   /* ½ Page up */
	{ KEY_HOME,       SEL_HOME },     /* First entry */
	{ KEY_END,        SEL_END },      /* Last entry */
	{ CONTROL('G'),   SEL_JUMP },     /* Jump to an entry number/offset */
	{ 'w',            SEL_SELMUL },   /* Toggle select multiple files */ // This is stupid but whatever
	{ '\t',           SEL_CYCLE },    /* Cycle contexts in forward direction */
	{ KEY_BTAB,       SEL_CYCLER },   /* Cycle contexts in reverse direction */
	
	{ CONTROL('N'),   SEL_NEW },      /* Create a new file */
	{ '!',            SEL_SHELL },    /* Run command */
	{ CONTROL('A'),   SEL_SELALL },   /* Select all files in current dir */
	{ 'I',            SEL_SELINV },   /* Invert selection in current dir */
	
	{ '.',            SEL_HIDDEN },   /* Toggle hide .dot files */ 
	{ 'D',            SEL_DETAIL },   /* Detailed listing */
	{ 'Y',            SEL_SELSIZE },  /* Show total size of listed selection */
	{ 'S',            SEL_SORT },     /* Sort toggles */ // change sorts
	{ 'T',            SEL_TIMETYPE }, /* Set time type */ // change which time attr is displayed
	{ '/',            SEL_FLTR },     /* Filter */ // "type stuff and it opens" type beat
	{ CONTROL('F'),   SEL_MFLTR },    /* Toggle filter mode */
	
	{ CONTROL('R'),   SEL_RENAMEMUL }, /* Rename contents of current dir */
	{ 'E',            SEL_SELEDIT },   /* List, edit selection */
	{ '>',            SEL_EXPORT },    /* Export list */ // WHAT
	
	{ ' ',            SEL_SEL },      /* Select current file path */
	{ 'm',            SEL_MV },       /* Move from selection buffer */
	{ CONTROL('V'),   SEL_CPMVAS },   /* Copy/move from selection buffer and rename */
	{ 'd',            SEL_RM },       /* Delete from selection buffer */
	// { CONTROL('V'),   SEL_CP },       /* Copy from selection buffer */
	
	{ KEY_ENTER,      SEL_OPEN },     /* Inside or select */
	{ 'r',            SEL_RENAME },   /* Show rename prompt */
	{ 'e',            SEL_EDIT },     /* Edit in EDITOR */
	{ 'o',            SEL_OPENWITH }, /* Open in a custom application */
	{ '=',            SEL_LAUNCH },   /* Launcher */
	{ 'i',            SEL_STATS },    /* File details */
	{ '*',            SEL_CHMODX },   /* Toggle executable status */
	{ 'z',            SEL_ARCHIVE },  /* Create archive */
	
	{ CONTROL('J'),   SEL_AUTONEXT }, /* Toggle auto-advance on file op */ // WHAT
	{ CONTROL('D'),   SEL_REDRAW },   /* Redraw window */ // ?
	
	/* Go to/create context N */
	{ '1',            SEL_CTX1 },
	{ '2',            SEL_CTX2 },
	{ '3',            SEL_CTX3 },
	{ '4',            SEL_CTX4 },
#ifdef CTX8
	{ '5',            SEL_CTX5 },
	{ '6',            SEL_CTX6 },
	{ '7',            SEL_CTX7 },
	{ '8',            SEL_CTX8 },
#endif
#ifndef NOMOUSE
	{ KEY_MOUSE,      SEL_CLICK },
#endif
	
	// { ',',            SEL_MARK },     /* Mark a path to visit later */ // WHAT
	// { 'B',            SEL_BMARK },    /* Create a bookmark */
	// { 's',            SEL_SESSIONS }, /* Manage sessions */ // WHAT
	// { ']',            SEL_PROMPT },   /* Show command prompt */
	// { '\'',           SEL_FIRST },    /* Go to first file */ // basically useless?
	// { 'Q',            SEL_QUITERR },  /* Quit with an error code */ // why?
	// { '0',            SEL_LOCK },     /* Lock screen */ // why?
	// { 'c',            SEL_REMOTE },    /* Connect to server over SSHFS */ // WHAT
	// { 'u',            SEL_UMOUNT },    /* Disconnect a SSHFS mount point */
	/* Show help */
};
