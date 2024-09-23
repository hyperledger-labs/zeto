// Copyright © 2024 Kaleido, Inc.
//
// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package log

import (
	"os"
	"sync/atomic"

	"github.com/sirupsen/logrus"
	prefixed "github.com/x-cray/logrus-prefixed-formatter"
)

var (
	rootLogger = logrus.NewEntry(logrus.StandardLogger())

	// L accesses the current logger from the context
	L = logger

	initAtLeastOnce atomic.Bool
)

func InitConfig() {
	initAtLeastOnce.Store(true) // must store before SetLevel

	logrus.SetLevel(logrus.InfoLevel)
	logrus.SetOutput(os.Stdout)
	var formatter logrus.Formatter
	formatter = &prefixed.TextFormatter{
		DisableColors:   false,
		ForceColors:     false,
		TimestampFormat: "2006-01-02T15:04:05.000Z07:00",
		DisableSorting:  false,
		FullTimestamp:   true,
	}
	logrus.SetReportCaller(true)
	formatter = &utcFormat{f: formatter}
	logrus.SetFormatter(formatter)
}

func ensureInit() {
	// Called at a couple of strategic points to check we get log initialize in things like unit tests
	// However NOT guaranteed to be called because we can't afford to do atomic load on every log line
	if !initAtLeastOnce.Load() {
		InitConfig()
	}
}

func logger() *logrus.Entry {
	ensureInit()
	return rootLogger
}

// WithLogField adds the specified field to the logger in the context
func WithLogField(key, value string) *logrus.Entry {
	ensureInit()
	if len(value) > 61 {
		value = value[0:61] + "..."
	}
	return rootLogger.WithField(key, value)
}

type utcFormat struct {
	f logrus.Formatter
}

func (utc *utcFormat) Format(e *logrus.Entry) ([]byte, error) {
	e.Time = e.Time.UTC()
	return utc.f.Format(e)
}
