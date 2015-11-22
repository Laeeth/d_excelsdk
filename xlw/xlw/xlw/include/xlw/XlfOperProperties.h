/*
 Copyright (C) 2011  John Adcock

 This file is part of XLW, a free-software/open-source C++ wrapper of the
 Excel C API - http://xlw.sourceforge.net/

 XLW is free software: you can redistribute it and/or modify it under the
 terms of the XLW license.  You should have received a copy of the
 license along with this program; if not, please email xlw-users@lists.sf.net

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

#ifndef INC_XlfOperProperties_H
#define INC_XlfOperProperties_H

/*!
\file XlfOperProperties.h
\brief defines a traits clas for each of the XLOPER variants
*/

// $Id: XlfOperProperties.h 1280 2011-08-07 11:33:52Z adcockj $

#include <xlw/xlcall32.h>
#include <xlw/PascalStringConversions.h>
#include <xlw/XlfExcel.h>
#include <xlw/XlfRef.h>
#include <xlw/XlfException.h>
#include <string>

namespace xlw { namespace impl {

    template <class LPOPER_TYPE>
    struct XlfOperProperties
    {
    };

} }

#include <xlw/XlfOperProperties4.inl>
#include <xlw/XlfOperProperties12.inl>
#include <xlw/XlfOperPropertiesDynamic.inl>

#endif
