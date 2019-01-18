import mongoose, { Schema } from 'mongoose'
import mongooseKeywords from 'mongoose-keywords'

const resourceSchema = new Schema({
  resourceName: {
    type: String,
    index: true,
    trim: true,
    required: true
  },
  totalScore: {
    type: Number,
    default: 0
  },
  averageScore: {
    type: Number,
    default: 0
  },
  overallScore: {
    type: Number,
    default: 0
  },
  organization: {
    type: Schema.ObjectId,
    ref: 'Organization',
    index: true
  }
}, {
  timestamps: true
})

resourceSchema.methods = {
  view () {
    const { id, resourceName, totalScore, averageScore, overallScore, createdAt } = this
    return {
      id,
      resourceName,
      totalScore,
      averageScore,
      overallScore,
      createdAt
    }
  }
}

resourceSchema.plugin(mongooseKeywords, { paths: ['resourceName'] })

const model = mongoose.model('Resource', resourceSchema)

export const schema = model.schema
export default model
