# coding: UTF-8

# Be sure to restart your server when you modify this file.

#Hilo3::Application.config.session_store :cookie_store, key: '_hilo_3_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
#Hilo::Application.config.session_store :cookie_store
Hilo::Application.config.session_store :active_record_store, :key => '_job_session' ,:secret => '626f30fc36f985bff54c3ae967c8df01bc26ae211ad44c74be1cdf46648f96db54683922ae9391fb3120af00eb76a6ecb0fe6a67acd820fc2d0a46a90dba8611' 