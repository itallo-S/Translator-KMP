package com.apps_s.translator_kmp.android.di

import android.app.Application
import app.cash.sqldelight.db.SqlDriver
import com.apps_s.translator_kmp.database.TranslateDatabase
import com.apps_s.translator_kmp.translate.data.history.SqlDelightHistoryDataSource
import com.apps_s.translator_kmp.translate.data.local.DatabaseDriverFactory
import com.apps_s.translator_kmp.translate.data.remote.HttpClientFactory
import com.apps_s.translator_kmp.translate.data.translate.KtorTranslateClient
import com.apps_s.translator_kmp.translate.domain.history.HistoryDataSource
import com.apps_s.translator_kmp.translate.domain.translate.Translate
import com.apps_s.translator_kmp.translate.domain.translate.TranslateClient
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import io.ktor.client.HttpClient
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideHttpClient(): HttpClient {
        return HttpClientFactory().create()
    }

    @Provides
    @Singleton
    fun provideTranslateClient(httpClient: HttpClient): TranslateClient {
        return KtorTranslateClient(httpClient)
    }

    @Provides
    @Singleton
    fun provideDatabaseDriver(app: Application): SqlDriver {
        return DatabaseDriverFactory(app).create()
    }

    @Provides
    @Singleton
    fun provideHistoryDataSource(driver: SqlDriver): HistoryDataSource {
        return SqlDelightHistoryDataSource(TranslateDatabase(driver))
    }

    @Provides
    @Singleton
    fun provideTranslateUseCase(
        client: TranslateClient,
        dataSource: HistoryDataSource
    ): Translate {
        return Translate(client, dataSource)
    }
}