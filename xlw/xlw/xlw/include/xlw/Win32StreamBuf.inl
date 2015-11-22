
/*
 Copyright (C) 1998, 1999, 2001, 2002, 2003 J�r�me Lecomte

 This file is part of xlw, a free-software/open-source C++ wrapper of the
 Excel C API - http://xlw.sourceforge.net/

 xlw is free software: you can redistribute it and/or modify it under the
 terms of the xlw license.  You should have received a copy of the
 license along with this program; if not, please email xlw-users@lists.sf.net

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

/*!
 * \file Win32StreamBuf.inl
 * \brief Inline implementation of the class Win32StreamBuf
 * \ingroup utils
 */

// $Id: Win32StreamBuf.inl 1280 2011-08-07 11:33:52Z adcockj $

namespace xlw {

    /*!
    This method is called to dump stuff in the put area out to the file.
    We intercept it to send to debug window.
    */
    inline int Win32StreamBuf::sync()
    {
        SendToDebugWindow();
        buf_.erase();
        return 0;
    }

    /*!
    This method is called to dump stuff in the put area out to the file.
    We intercept it to send to debug window.
    */
    inline Win32StreamBuf::int_type Win32StreamBuf::overflow(int_type ch)
    {
        if (!traits_type::eq_int_type(traits_type::eof(), ch))
        {
            buf_.append(1, traits_type::to_char_type(ch));
        }
        else
        {
            return sync();
        }
        return traits_type::not_eof(ch);
    }

}

