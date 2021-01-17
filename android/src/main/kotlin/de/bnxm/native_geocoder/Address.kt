package de.bnxm.native_geocoder

import android.location.Address

internal fun Address.toMap() : HashMap<*, *> {
    val map = HashMap<String, Any?>()

    map["addressLines"] = (0 until maxAddressLineIndex).map { getAddressLine(it) }
    map["thoroughfare"] = thoroughfare
    map["subThoroughfare"] = subThoroughfare
    map["locality"] = locality
    map["subLocality"] = subLocality
    map["subAdminArea"] = subAdminArea
    map["adminArea"] = adminArea
    map["countryCode"] = countryCode
    map["countryName"] = countryName
    map["postalCode"] = postalCode

    map["latitude"] = latitude
    map["longitude"] = longitude

    return map
}