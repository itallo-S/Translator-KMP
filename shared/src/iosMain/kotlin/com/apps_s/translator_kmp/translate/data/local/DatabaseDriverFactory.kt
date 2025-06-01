package com.apps_s.translator_kmp.translate.data.local

import app.cash.sqldelight.db.SqlDriver
import app.cash.sqldelight.driver.native.NativeSqliteDriver
import com.apps_s.translator_kmp.database.TranslateDatabase

actual class DatabaseDriverFactory {
    actual fun create(): SqlDriver {
        return NativeSqliteDriver(
            TranslateDatabase.Schema,
            name = "translate.db"
        )
    }
}