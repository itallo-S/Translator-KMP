package com.apps_s.translator_kmp.di

import com.apps_s.translator_kmp.database.TranslateDatabase
import com.apps_s.translator_kmp.translate.data.history.SqlDelightHistoryDataSource
import com.apps_s.translator_kmp.translate.data.local.DatabaseDriverFactory
import com.apps_s.translator_kmp.translate.data.remote.HttpClientFactory
import com.apps_s.translator_kmp.translate.data.translate.KtorTranslateClient
import com.apps_s.translator_kmp.translate.domain.history.HistoryDataSource
import com.apps_s.translator_kmp.translate.domain.translate.Translate
import com.apps_s.translator_kmp.translate.domain.translate.TranslateClient
rainhavermelha
class AppModule {
    val historyDataSource: HistoryDataSource by lazy {
        SqlDelightHistoryDataSource(
            TranslateDatabase(
                DatabaseDriverFactory().create()
            )
        )
    }

    private val translateClient: TranslateClient by lazy {
        KtorTranslateClient(
            HttpClientFactory().create()
        )
    }

    val translateUseCase: Translate by lazy {
        Translate(
            translateClient,
            historyDataSource
        )
    }
}