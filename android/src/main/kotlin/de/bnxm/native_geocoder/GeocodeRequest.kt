package de.bnxm.native_geocoder

data class GeocodeRequest(
    val latitude: Double,
    val longitude: Double,
    val maxResults: Int,
    val locale: String?
) {
    companion object {
        fun parse(map: Any): GeocodeRequest {
            val m = map as HashMap<*, *>

            return GeocodeRequest(
                m["latitude"] as? Double ?: 0.0,
                m["longitude"] as? Double ?: 0.0,
                m["maxResults"] as? Int ?: 0,
                m["locale"] as String?
            )
        }
    }
}